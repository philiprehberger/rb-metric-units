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

    # Data: base = bytes. Includes both decimal (SI) and binary (IEC) units.
    DATA_FACTORS = {
      bytes: 1.0,
      kilobytes: 1_000.0,
      megabytes: 1_000_000.0,
      gigabytes: 1_000_000_000.0,
      terabytes: 1_000_000_000_000.0,
      petabytes: 1_000_000_000_000_000.0,
      kibibytes: 1024.0,
      mebibytes: 1_048_576.0,
      gibibytes: 1_073_741_824.0,
      tebibytes: 1_099_511_627_776.0,
      pebibytes: 1_125_899_906_842_624.0
    }.freeze

    TEMPERATURE_UNITS = %i[celsius fahrenheit kelvin].freeze

    CATEGORY_MAP = {
      length: LENGTH_FACTORS,
      weight: WEIGHT_FACTORS,
      volume: VOLUME_FACTORS,
      temperature: nil,
      speed: SPEED_FACTORS,
      pressure: PRESSURE_FACTORS,
      energy: ENERGY_FACTORS,
      data: DATA_FACTORS
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
      kilowatt_hours: 'kWh', btu: 'BTU',
      # Data
      bytes: 'B', kilobytes: 'kB', megabytes: 'MB',
      gigabytes: 'GB', terabytes: 'TB', petabytes: 'PB',
      kibibytes: 'KiB', mebibytes: 'MiB', gibibytes: 'GiB',
      tebibytes: 'TiB', pebibytes: 'PiB'
    }.freeze

    # Alias map: any token a user might write (symbols, abbreviations, plurals)
    # mapped to the canonical unit symbol used by the CATEGORY_MAP.
    ALIASES = {
      # Length
      'kilometer' => :km, 'kilometers' => :km, 'kilometre' => :km, 'kilometres' => :km, 'km' => :km,
      'meter' => :m, 'meters' => :m, 'metre' => :m, 'metres' => :m, 'm' => :m,
      'centimeter' => :cm, 'centimeters' => :cm, 'cm' => :cm,
      'millimeter' => :mm, 'millimeters' => :mm, 'mm' => :mm,
      'mile' => :miles, 'miles' => :miles, 'mi' => :miles,
      'yard' => :yards, 'yards' => :yards, 'yd' => :yards,
      'foot' => :feet, 'feet' => :feet, 'ft' => :feet,
      'inch' => :inches, 'inches' => :inches, 'in' => :inches,
      # Weight
      'kilogram' => :kg, 'kilograms' => :kg, 'kg' => :kg,
      'gram' => :g, 'grams' => :g, 'g' => :g,
      'milligram' => :mg, 'milligrams' => :mg, 'mg' => :mg,
      'pound' => :lbs, 'pounds' => :lbs, 'lb' => :lbs, 'lbs' => :lbs,
      'ounce' => :oz, 'ounces' => :oz, 'oz' => :oz,
      # Volume
      'liter' => :liters, 'liters' => :liters, 'litre' => :liters,
      'litres' => :liters, 'l' => :liters,
      'milliliter' => :ml, 'milliliters' => :ml, 'ml' => :ml,
      'gallon' => :gallons, 'gallons' => :gallons, 'gal' => :gallons,
      'quart' => :quarts, 'quarts' => :quarts, 'qt' => :quarts,
      'pint' => :pints, 'pints' => :pints, 'pt' => :pints,
      'cup' => :cups, 'cups' => :cups,
      # Temperature
      'c' => :celsius, 'celsius' => :celsius, "\u00B0c" => :celsius,
      'f' => :fahrenheit, 'fahrenheit' => :fahrenheit, "\u00B0f" => :fahrenheit,
      'k' => :kelvin, 'kelvin' => :kelvin,
      # Speed
      'm/s' => :meters_per_second, 'mps' => :meters_per_second,
      'km/h' => :kilometers_per_hour, 'kph' => :kilometers_per_hour, 'kmh' => :kilometers_per_hour,
      'mph' => :miles_per_hour, 'mi/h' => :miles_per_hour,
      'kn' => :knots, 'kt' => :knots, 'knot' => :knots, 'knots' => :knots,
      'ft/s' => :feet_per_second, 'fps' => :feet_per_second,
      # Pressure
      'pa' => :pascals, 'pascal' => :pascals, 'pascals' => :pascals,
      'kpa' => :kilopascals, 'kilopascal' => :kilopascals, 'kilopascals' => :kilopascals,
      'bar' => :bar, 'bars' => :bar,
      'psi' => :psi,
      'atm' => :atmospheres, 'atmosphere' => :atmospheres, 'atmospheres' => :atmospheres,
      'mmhg' => :mmhg, 'torr' => :mmhg,
      # Energy
      'j' => :joules, 'joule' => :joules, 'joules' => :joules,
      'kj' => :kilojoules, 'kilojoule' => :kilojoules, 'kilojoules' => :kilojoules,
      'cal' => :calories, 'calorie' => :calories, 'calories' => :calories,
      'kcal' => :kilocalories, 'kilocalorie' => :kilocalories, 'kilocalories' => :kilocalories,
      'wh' => :watt_hours, 'watt_hour' => :watt_hours, 'watt_hours' => :watt_hours,
      'kwh' => :kilowatt_hours, 'kilowatt_hour' => :kilowatt_hours, 'kilowatt_hours' => :kilowatt_hours,
      'btu' => :btu,
      # Data
      'b' => :bytes, 'byte' => :bytes, 'bytes' => :bytes,
      'kb' => :kilobytes, 'kilobyte' => :kilobytes, 'kilobytes' => :kilobytes,
      'mb' => :megabytes, 'megabyte' => :megabytes, 'megabytes' => :megabytes,
      'gb' => :gigabytes, 'gigabyte' => :gigabytes, 'gigabytes' => :gigabytes,
      'tb' => :terabytes, 'terabyte' => :terabytes, 'terabytes' => :terabytes,
      'pb' => :petabytes, 'petabyte' => :petabytes, 'petabytes' => :petabytes,
      'kib' => :kibibytes, 'kibibyte' => :kibibytes, 'kibibytes' => :kibibytes,
      'mib' => :mebibytes, 'mebibyte' => :mebibytes, 'mebibytes' => :mebibytes,
      'gib' => :gibibytes, 'gibibyte' => :gibibytes, 'gibibytes' => :gibibytes,
      'tib' => :tebibytes, 'tebibyte' => :tebibytes, 'tebibytes' => :tebibytes,
      'pib' => :pebibytes, 'pebibyte' => :pebibytes, 'pebibytes' => :pebibytes
    }.freeze

    # Ordered scales used by .humanize_bytes for auto-scaling
    HUMANIZE_BYTES_DECIMAL = %i[bytes kilobytes megabytes gigabytes terabytes petabytes].freeze
    HUMANIZE_BYTES_BINARY = %i[bytes kibibytes mebibytes gibibytes tebibytes pebibytes].freeze

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

      from_category = internal_category_for(from)
      to_category = internal_category_for(to)

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

    # Return a mapping of every category to its units.
    #
    # Equivalent to calling {units_for} for each entry in {categories}, but
    # returned in a single call. Useful for populating UI pickers.
    #
    # @return [Hash{Symbol => Array<Symbol>}] category name to array of unit symbols
    def self.all_units
      categories.to_h { |cat| [cat, units_for(cat)] }
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

    # Convert a value between units and return a formatted string in the target unit.
    #
    # Combines {.convert} and {.format} into a single call, using fixed-point
    # formatting that preserves trailing zeros (e.g. precision 2 yields "5.00 km").
    #
    # @param value [Numeric] the value to convert
    # @param from [Symbol, String] the source unit
    # @param to [Symbol, String] the target unit
    # @param precision [Integer] decimal places in the output (default: 2)
    # @return [String] formatted string, e.g. "5.00 km"
    # @raise [Error] if units are unknown, incompatible, value is non-numeric,
    #   or precision is invalid
    def self.convert_and_format(value, from:, to:, precision: 2)
      raise Error, 'precision must be a non-negative integer' unless precision.is_a?(Integer) && precision >= 0

      converted = convert(value, from: from, to: to)
      abbr = abbreviation(to)
      raise Error, "unknown unit abbreviation: #{to}" unless abbr

      "#{Kernel.format("%.#{precision}f", converted)} #{abbr}"
    end

    # Format a value range with a shared unit, producing strings such as
    # `"5-10 km"`. The range is normalized so the smaller value appears first
    # and both endpoints are rounded to the requested `precision`. When both
    # endpoints round to the same value the single value is returned.
    #
    # @param min [Numeric] the lower bound
    # @param max [Numeric] the upper bound
    # @param unit [Symbol, String] the unit shared by both bounds
    # @param precision [Integer] decimal places (default: 2)
    # @param separator [String] range separator (default: an en-dash)
    # @return [String] the formatted range
    # @raise [Error] if either bound is non-numeric or the unit is unknown
    def self.format_range(min, max, unit, precision: 2, separator: '–')
      raise Error, 'min must be numeric' unless min.is_a?(Numeric)
      raise Error, 'max must be numeric' unless max.is_a?(Numeric)

      abbr = abbreviation(unit)
      raise Error, "unknown unit abbreviation: #{unit}" unless abbr

      lo, hi = [min, max].minmax
      lo_r = lo.round(precision)
      hi_r = hi.round(precision)
      return "#{lo_r} #{abbr}" if lo_r == hi_r

      "#{lo_r}#{separator}#{hi_r} #{abbr}"
    end

    # Return the category a unit belongs to.
    #
    # @param unit [Symbol, String] the unit name
    # @return [Symbol, nil] the category symbol, or nil if unknown
    def self.category_for(unit)
      unit_sym = unit.to_sym
      return :temperature if TEMPERATURE_UNITS.include?(unit_sym)

      internal_category_for(unit_sym)
    end

    # Check whether two units belong to the same category and can be converted
    # between one another.
    #
    # Useful for pair-validating units before calling {.convert}. Returns
    # +false+ if either unit is unknown.
    #
    # @param unit1 [Symbol, String] the first unit name
    # @param unit2 [Symbol, String] the second unit name
    # @return [Boolean] true iff both units belong to the same category
    def self.compatible?(unit1, unit2)
      cat1 = category_for(unit1)
      cat2 = category_for(unit2)
      !cat1.nil? && cat1 == cat2
    end

    # Parse a string like "5 km", "3.14kg", or "72°F" into [value, unit_symbol].
    #
    # @param string [String] the string to parse
    # @return [Array(Float, Symbol)] a two-element array: [value, canonical unit symbol]
    # @raise [Error] if the string cannot be parsed or the unit is unknown
    def self.parse(string)
      raise Error, 'value must be a string' unless string.is_a?(String)

      trimmed = string.strip
      raise Error, 'cannot parse empty string' if trimmed.empty?

      match = trimmed.match(/\A(-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)\s*(.+?)\z/)
      raise Error, "cannot parse: #{string.inspect}" unless match

      value = Float(match[1])
      token = match[2].strip.downcase
      unit = ALIASES[token]
      raise Error, "unknown unit: #{match[2]}" unless unit

      [value, unit]
    end

    # Parse a string and convert it to another unit in one step.
    #
    # @param string [String] the input, e.g. "5 km"
    # @param to [Symbol, String] the target unit
    # @return [Float] the converted numeric value
    # @raise [Error] if the string cannot be parsed or units are incompatible
    def self.convert_str(string, to:)
      value, from = parse(string)
      convert(value, from: from, to: to)
    end

    # Auto-scale a byte count to a human-readable string.
    #
    # @param bytes [Numeric] the byte count (may be negative)
    # @param binary [Boolean] if true, use IEC (KiB/MiB/...); if false, SI (kB/MB/...)
    # @param precision [Integer] decimal places in the output (default: 2)
    # @return [String] formatted string, e.g. "1.50 MB" or "1.50 MiB"
    # @raise [Error] if bytes is not numeric or precision is negative
    def self.humanize_bytes(bytes, binary: false, precision: 2)
      raise Error, 'bytes must be numeric' unless bytes.is_a?(Numeric)
      raise Error, 'precision must be a non-negative integer' unless precision.is_a?(Integer) && precision >= 0

      sign = bytes.negative? ? -1 : 1
      abs = bytes.abs.to_f
      units = binary ? HUMANIZE_BYTES_BINARY : HUMANIZE_BYTES_DECIMAL
      step = binary ? 1024.0 : 1000.0

      unit = units.first
      value = abs
      units.each_with_index do |candidate, idx|
        threshold = step**idx
        next_threshold = step**(idx + 1)
        next unless abs < next_threshold || idx == units.length - 1

        unit = candidate
        value = abs / threshold
        break
      end

      self.format(sign * value, unit, precision: precision)
    end

    # @api private
    def self.internal_category_for(unit)
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

    private_class_method :internal_category_for, :temperature_unit?, :convert_temperature,
                         :to_celsius, :from_celsius
  end
end
