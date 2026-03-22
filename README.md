# philiprehberger-metric_units

[![Tests](https://github.com/philiprehberger/rb-metric-units/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-metric-units/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-metric_units.svg)](https://rubygems.org/gems/philiprehberger-metric_units)
[![License](https://img.shields.io/github/license/philiprehberger/rb-metric-units)](LICENSE)

Unit conversion for length, weight, temperature, and volume measurements

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

### Discovering Units

```ruby
Philiprehberger::MetricUnits.categories
# => [:length, :weight, :volume, :temperature]

Philiprehberger::MetricUnits.units_for(:length)
# => [:km, :m, :cm, :mm, :miles, :yards, :feet, :inches]
```

## API

| Method | Description |
|--------|-------------|
| `.convert(value, from:, to:)` | Convert a value between units |
| `.categories` | Return all available categories |
| `.units_for(category)` | Return all units for a category |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
