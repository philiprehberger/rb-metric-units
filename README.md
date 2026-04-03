# philiprehberger-metric_units

[![Tests](https://github.com/philiprehberger/rb-metric-units/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-metric-units/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-metric_units.svg)](https://rubygems.org/gems/philiprehberger-metric_units)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-metric-units)](https://github.com/philiprehberger/rb-metric-units/commits/main)

Unit conversion for length, weight, temperature, volume, speed, pressure, and energy measurements

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

### Discovering Units

```ruby
Philiprehberger::MetricUnits.categories
# => [:length, :weight, :volume, :temperature, :speed, :pressure, :energy]

Philiprehberger::MetricUnits.units_for(:length)
# => [:km, :m, :cm, :mm, :miles, :yards, :feet, :inches]
```

## API

| Method / Constant | Description |
|--------------------|-------------|
| `.convert(value, from:, to:)` | Convert a numeric value between compatible units |
| `.categories` | Return all available category names as symbols |
| `.units_for(category)` | Return all unit symbols for a given category |
| `.abbreviation(unit)` | Return the standard abbreviation for a unit (e.g., `"km/h"`) |
| `.format(value, unit, precision: 2)` | Format a value with its unit abbreviation (e.g., `"3.14 kg"`) |
| `Error` | Custom error class raised for unknown or incompatible units |
| `VERSION` | Gem version string |
| `LENGTH_FACTORS` | Hash mapping length unit symbols to meter conversion factors |
| `WEIGHT_FACTORS` | Hash mapping weight unit symbols to gram conversion factors |
| `VOLUME_FACTORS` | Hash mapping volume unit symbols to liter conversion factors |
| `SPEED_FACTORS` | Hash mapping speed unit symbols to m/s conversion factors |
| `PRESSURE_FACTORS` | Hash mapping pressure unit symbols to pascal conversion factors |
| `ENERGY_FACTORS` | Hash mapping energy unit symbols to joule conversion factors |
| `TEMPERATURE_UNITS` | Array of supported temperature unit symbols |
| `ABBREVIATIONS` | Hash mapping unit symbols to abbreviation strings |
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
