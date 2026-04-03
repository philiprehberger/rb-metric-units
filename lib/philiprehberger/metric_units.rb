# frozen_string_literal: true

require_relative 'metric_units/version'

module Philiprehberger
  module MetricUnits
    class Error < StandardError; end

    # Conversion factors to base unit per category
    # Length: base = meters
    # Weight: base = grams
    # Volume: base = liters
    LENGTH_FACTORS = {
      km: 1000.0,
      m: 1.0,
      cm: 0.01,
      mm: 0.001,
      miles: 1609.344,
      yards: 0.9144,
      feet: 0.3048,
      inches: 0.0254
    }.freeze

    WEIGHT_FACTORS = {
      kg: 1000.0,
      g: 1.0,
      mg: 0.001,
      lbs: 453.59237,
      oz: 28.349523125
    }.freeze

    VOLUME_FACTORS = {
      liters: 1.0,
      ml: 0.001,
      gallons: 3.785411784,
      quarts: 0.946352946,
      pints: 0.473176473,
      cups: 0.2365882365
    }.freeze

    SPEED_FACTORS = {
      meters_per_second: 1.0,
      kilometers_per_hour: 1.0 / 3.6,
      miles_per_hour: 0.44704,
      knots: 0.514444,
      feet_per_second: 0.3048
    }.freeze

    PRESSURE_FACTORS = {
      pascals: 1.0,
      kilopascals: 1000.0,
      bar: 100_000.0,
      psi: 6894.757,
      atmospheres: 101_325.0,
      mmhg: 133.322
    }.freeze

    ENERGY_FACTORS = {
      joules: 1.0,
      kilojoules: 1000.0,
      calories: 4.184,
      kilocalories: 4184.0,
      watt_hours: 3600.0,
      kilowatt_hours: 3_600_000.0,
      btu: 1055.06
    }.freeze

    TEMPERATURE_UNITS = %i[celsius fahrenheit kelvin].freeze

    CATEGORY_MAP = {
      length: LENGTH_FACTORS,
      weight: WEIGHT_FACTORS,
      volume: VOLUME_FACTORS,
      temperature: nil,
      speed: SPEED_FACTORS,
      pressure: PRESSURE_FACTORS,
      energy: ENERGY_FACTORS
    }.freeze

    ABBREVIATIONS = {
      # Length
      km: 'km', m: 'm', cm: 'cm', mm: 'mm',
      miles: 'mi', yards: 'yd', feet: 'ft', inches: 'in',
      # Weight
      kg: 'kg', g: 'g', mg: 'mg', lbs: 'lb', oz: 'oz',
      # Volume
      liters: 'L', ml: 'mL',
      gallons: 'gal', quarts: 'qt', pints: 'pt', cups: 'cup',
      # Temperature
      celsius: "\u00B0C", fahrenheit: "\u00B0F", kelvin: 'K',
      # Speed
      meters_per_second: 'm/s', kilometers_per_hour: 'km/h',
      miles_per_hour: 'mph', knots: 'kn', feet_per_second: 'ft/s',
      # Pressure
      pascals: 'Pa', kilopascals: 'kPa', bar: 'bar',
      psi: 'psi', atmospheres: 'atm', mmhg: 'mmHg',
      # Energy
      joules: 'J', kilojoules: 'kJ', calories: 'cal',
      kilocalories: 'kcal', watt_hours: 'Wh',
      kilowatt_hours: 'kWh', btu: 'BTU'
    }.freeze

    # Convert a value from one unit to another
    #
    # @param value [Numeric] the value to convert
    # @param from [Symbol] the source unit
    # @param to [Symbol] the target unit
    # @return [Float] the converted value
    # @raise [Error] if units are unknown or incompatible
    def self.convert(value, from:, to:)
      raise Error, 'value must be numeric' unless value.is_a?(Numeric)

      from = from.to_sym
      to = to.to_sym

      return convert_temperature(value, from, to) if temperature_unit?(from) || temperature_unit?(to)

      from_category = category_for(from)
      to_category = category_for(to)

      raise Error, "unknown unit: #{from}" unless from_category
      raise Error, "unknown unit: #{to}" unless to_category
      raise Error, "cannot convert between #{from_category} and #{to_category}" unless from_category == to_category

      factors = CATEGORY_MAP[from_category]
      base_value = value * factors[from]
      base_value / factors[to]
    end

    # Return all available categories
    #
    # @return [Array<Symbol>]
    def self.categories
      CATEGORY_MAP.keys
    end

    # Return all units for a given category
    #
    # @param category [Symbol] the category name
    # @return [Array<Symbol>]
    # @raise [Error] if category is unknown
    def self.units_for(category)
      category = category.to_sym
      raise Error, "unknown category: #{category}" unless CATEGORY_MAP.key?(category)

      return TEMPERATURE_UNITS if category == :temperature

      CATEGORY_MAP[category].keys
    end

    # Return the standard abbreviation for a unit
    #
    # @param unit [Symbol, String] the unit name
    # @return [String, nil] the abbreviation, or nil if unknown
    def self.abbreviation(unit)
      ABBREVIATIONS[unit.to_sym]
    end

    # Format a value with its unit abbreviation
    #
    # @param value [Numeric] the value to format
    # @param unit [Symbol, String] the unit name
    # @param precision [Integer] decimal places (default: 2)
    # @return [String] formatted string, e.g. "3.14 kg"
    # @raise [Error] if unit abbreviation is unknown
    def self.format(value, unit, precision: 2)
      raise Error, 'value must be numeric' unless value.is_a?(Numeric)

      abbr = abbreviation(unit)
      raise Error, "unknown unit abbreviation: #{unit}" unless abbr

      "#{value.round(precision)} #{abbr}"
    end

    # @api private
    def self.category_for(unit)
      CATEGORY_MAP.each do |cat, factors|
        next if cat == :temperature

        return cat if factors&.key?(unit)
      end
      nil
    end

    # @api private
    def self.temperature_unit?(unit)
      TEMPERATURE_UNITS.include?(unit)
    end

    # @api private
    def self.convert_temperature(value, from, to)
      raise Error, "unknown temperature unit: #{from}" unless TEMPERATURE_UNITS.include?(from)
      raise Error, "unknown temperature unit: #{to}" unless TEMPERATURE_UNITS.include?(to)

      return value.to_f if from == to

      celsius = to_celsius(value, from)
      from_celsius(celsius, to)
    end

    # @api private
    def self.to_celsius(value, unit)
      case unit
      when :celsius then value.to_f
      when :fahrenheit then (value - 32) * 5.0 / 9.0
      when :kelvin then value - 273.15
      end
    end

    # @api private
    def self.from_celsius(celsius, unit)
      case unit
      when :celsius then celsius
      when :fahrenheit then (celsius * 9.0 / 5.0) + 32
      when :kelvin then celsius + 273.15
      end
    end

    private_class_method :category_for, :temperature_unit?, :convert_temperature, :to_celsius, :from_celsius
  end
end
