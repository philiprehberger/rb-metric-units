# philiprehberger-metric_units

[![Tests](https://github.com/philiprehberger/rb-metric-units/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-metric-units/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-metric_units.svg)](https://rubygems.org/gems/philiprehberger-metric_units)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-metric-units)](https://github.com/philiprehberger/rb-metric-units/commits/main)

Unit conversion for length, weight, temperature, volume, speed, pressure, energy, and data measurements

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-metric_units"
```

Or install directly:

```bash
gem install philiprehberger-metric_units
```

## Usage

```ruby
require "philiprehberger/metric_units"

Philiprehberger::MetricUnits.convert(100, from: :km, to: :miles)
# => 62.137...
```

### Temperature

```ruby
Philiprehberger::MetricUnits.convert(72, from: :fahrenheit, to: :celsius)
# => 22.222...

Philiprehberger::MetricUnits.convert(0, from: :celsius, to: :kelvin)
# => 273.15
```

### Weight

```ruby
Philiprehberger::MetricUnits.convert(1, from: :kg, to: :lbs)
# => 2.205...
```

### Speed

```ruby
Philiprehberger::MetricUnits.convert(100, from: :kilometers_per_hour, to: :miles_per_hour)
# => 62.137...

Philiprehberger::MetricUnits.convert(10, from: :meters_per_second, to: :knots)
# => 19.438...
```

### Pressure

```ruby
Philiprehberger::MetricUnits.convert(1, from: :atmospheres, to: :kilopascals)
# => 101.325

Philiprehberger::MetricUnits.convert(14.5, from: :psi, to: :bar)
# => 0.999...
```

### Energy

```ruby
Philiprehberger::MetricUnits.convert(1, from: :kilowatt_hours, to: :btu)
# => 3412.14...

Philiprehberger::MetricUnits.convert(1, from: :kilocalories, to: :kilojoules)
# => 4.184
```

### Data

```ruby
Philiprehberger::MetricUnits.convert(1, from: :gigabytes, to: :megabytes)
# => 1000.0

Philiprehberger::MetricUnits.convert(1, from: :gibibytes, to: :mebibytes)
# => 1024.0
```

### Parsing Strings

```ruby
Philiprehberger::MetricUnits.parse("5 km")
# => [5.0, :km]

Philiprehberger::MetricUnits.parse("3.14kg")
# => [3.14, :kg]

Philiprehberger::MetricUnits.parse("72 °F")
# => [72.0, :fahrenheit]
```

### Parse and Convert

```ruby
Philiprehberger::MetricUnits.convert_str("5 MB", to: :bytes)
# => 5000000.0

Philiprehberger::MetricUnits.convert_str("1 mile", to: :km)
# => 1.609...
```

### Humanize Bytes

```ruby
Philiprehberger::MetricUnits.humanize_bytes(1_500_000)
# => "1.5 MB"

Philiprehberger::MetricUnits.humanize_bytes(1_500_000, binary: true)
# => "1.43 MiB"

Philiprehberger::MetricUnits.humanize_bytes(2_500_000_000, precision: 1)
# => "2.5 GB"
```

### Category Lookup

```ruby
Philiprehberger::MetricUnits.category_for(:kg)
# => :weight

Philiprehberger::MetricUnits.category_for(:celsius)
# => :temperature

Philiprehberger::MetricUnits.category_for(:parsecs)
# => nil
```

### Compatibility check

```ruby
Philiprehberger::MetricUnits.compatible?(:m, :km) # => true
Philiprehberger::MetricUnits.compatible?(:m, :kg) # => false
```

### Abbreviations

```ruby
Philiprehberger::MetricUnits.abbreviation(:kilometers_per_hour)
# => "km/h"

Philiprehberger::MetricUnits.abbreviation(:celsius)
# => "°C"
```

### Formatted Output

```ruby
Philiprehberger::MetricUnits.format(3.14159, :kg, precision: 2)
# => "3.14 kg"

Philiprehberger::MetricUnits.format(100.5, :kilometers_per_hour)
# => "100.5 km/h"
```

### Convert and Format

```ruby
Philiprehberger::MetricUnits.convert_and_format(5000, from: :m, to: :km)
# => "5.00 km"

Philiprehberger::MetricUnits.convert_and_format(1, from: :kg, to: :lbs, precision: 4)
# => "2.2046 lb"
```

### Value Ranges

```ruby
Philiprehberger::MetricUnits.format_range(5, 10, :km, precision: 0)
# => "5–10 km"

Philiprehberger::MetricUnits.format_range(5, 10, :km, precision: 0, separator: " to ")
# => "5 to 10 km"

Philiprehberger::MetricUnits.format_range(5.001, 5.002, :km, precision: 1)
# => "5.0 km"
```

### Discovering Units

```ruby
Philiprehberger::MetricUnits.categories
# => [:length, :weight, :volume, :temperature, :speed, :pressure, :energy, :data]

Philiprehberger::MetricUnits.units_for(:length)
# => [:km, :m, :cm, :mm, :miles, :yards, :feet, :inches]

Philiprehberger::MetricUnits.all_units
# => { length: [:km, :m, ...], weight: [:kg, :g, ...], temperature: [:celsius, :fahrenheit, :kelvin], ... }
```

## API

| Method / Constant | Description |
|--------------------|-------------|
| `.convert(value, from:, to:)` | Convert a numeric value between compatible units |
| `.convert_str(string, to:)` | Parse a string (e.g. `"5 km"`) and convert to the target unit |
| `.parse(string)` | Parse a string into `[value, unit]` (e.g. `"5 km"` to `[5.0, :km]`) |
| `.humanize_bytes(bytes, binary: false, precision: 2)` | Auto-scale a byte count to a human-readable string |
| `.category_for(unit)` | Return the category a unit belongs to, or `nil` if unknown |
| `.compatible?(unit1, unit2)` | Return true iff both units belong to the same category |
| `.categories` | Return all available category names as symbols |
| `.units_for(category)` | Return all unit symbols for a given category |
| `.all_units` | Return a hash mapping each category to its unit symbols |
| `.abbreviation(unit)` | Return the standard abbreviation for a unit (e.g., `"km/h"`) |
| `.format(value, unit, precision: 2)` | Format a value with its unit abbreviation (e.g., `"3.14 kg"`) |
| `.convert_and_format(value, from:, to:, precision: 2)` | Convert a value and return a formatted string in the target unit (e.g., `"5.00 km"`) |
| `.format_range(min, max, unit, precision: 2, separator: '–')` | Format a value range (e.g., `"5–10 km"`); collapses to a single value when both endpoints round identically |
| `Error` | Custom error class raised for unknown or incompatible units |
| `VERSION` | Gem version string |
| `LENGTH_FACTORS` | Hash mapping length unit symbols to meter conversion factors |
| `WEIGHT_FACTORS` | Hash mapping weight unit symbols to gram conversion factors |
| `VOLUME_FACTORS` | Hash mapping volume unit symbols to liter conversion factors |
| `SPEED_FACTORS` | Hash mapping speed unit symbols to m/s conversion factors |
| `PRESSURE_FACTORS` | Hash mapping pressure unit symbols to pascal conversion factors |
| `ENERGY_FACTORS` | Hash mapping energy unit symbols to joule conversion factors |
| `DATA_FACTORS` | Hash mapping data unit symbols to byte conversion factors (SI and IEC) |
| `TEMPERATURE_UNITS` | Array of supported temperature unit symbols |
| `ABBREVIATIONS` | Hash mapping unit symbols to abbreviation strings |
| `ALIASES` | Hash mapping common tokens (plurals, abbreviations) to canonical unit symbols |
| `CATEGORY_MAP` | Hash mapping category names to their factor tables |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Support

If you find this project useful:

⭐ [Star the repo](https://github.com/philiprehberger/rb-metric-units)

🐛 [Report issues](https://github.com/philiprehberger/rb-metric-units/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

💡 [Suggest features](https://github.com/philiprehberger/rb-metric-units/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)

❤️ [Sponsor development](https://github.com/sponsors/philiprehberger)

🌐 [All Open Source Projects](https://philiprehberger.com/open-source-packages)

💻 [GitHub Profile](https://github.com/philiprehberger)

🔗 [LinkedIn Profile](https://www.linkedin.com/in/philiprehberger)

## License

[MIT](LICENSE)
