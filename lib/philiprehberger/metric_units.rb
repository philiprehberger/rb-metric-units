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

    TEMPERATURE_UNITS = %i[celsius fahrenheit kelvin].freeze

    CATEGORY_MAP = {
      length: LENGTH_FACTORS,
      weight: WEIGHT_FACTORS,
      volume: VOLUME_FACTORS,
      temperature: nil
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
      when :fahrenheit then celsius * 9.0 / 5.0 + 32
      when :kelvin then celsius + 273.15
      end
    end

    private_class_method :category_for, :temperature_unit?, :convert_temperature, :to_celsius, :from_celsius
  end
end
