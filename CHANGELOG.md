# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.6.0] - 2026-04-20

### Added
- `MetricUnits.format_range(min, max, unit, precision:, separator:)` — formats value ranges (e.g. `"5–10 km"`) with automatic ascending normalization, collapsing the output to a single value when both endpoints round identically.

## [0.5.0] - 2026-04-19

### Added
- `MetricUnits.compatible?(unit1, unit2)` — returns true iff both units belong to the same category; pair-validate units before calling `convert`

## [0.4.0] - 2026-04-15

### Added
- `convert_and_format` method that converts a value between units and returns a formatted string with the target unit abbreviation (e.g. `"5.00 km"`), with a configurable `precision` parameter

## [0.3.0] - 2026-04-15

### Added
- `parse` method that converts strings like `"5 km"` or `"3.14kg"` into `[value, unit]`
- `convert_str` method that parses a string and converts it to a target unit in one step
- `humanize_bytes` method that auto-scales byte counts to human-readable strings (`binary: true` for IEC KiB/MiB/...)
- `category_for` public method to look up which category a unit belongs to (including `:temperature`)
- Data unit category (`bytes`, `kilobytes`, `megabytes`, `gigabytes`, `terabytes`, `petabytes`, `kibibytes`, `mebibytes`, `gibibytes`, `tebibytes`, `pebibytes`) with SI and IEC factors
- `ALIASES` constant mapping common unit tokens (plurals, abbreviations, symbols) to canonical unit symbols

### Changed
- `categories` now includes the new `:data` category

## [0.2.0] - 2026-04-03

### Added
- Speed unit category (m/s, km/h, mph, knots, ft/s)
- Pressure unit category (Pa, kPa, bar, psi, atm, mmHg)
- Energy unit category (J, kJ, cal, kcal, Wh, kWh, BTU)
- `abbreviation` method for standard unit abbreviations
- `format` method for formatted output with precision control

## [0.1.4] - 2026-03-31

### Added
- Add GitHub issue templates, dependabot config, and PR template

## [0.1.3] - 2026-03-31

### Changed
- Standardize README badges, support section, and license format

## [0.1.2] - 2026-03-24

### Changed
- Expand README API table to document all public methods

## [0.1.1] - 2026-03-22

### Changed
- Expand test coverage to 51 examples

## [0.1.0] - 2026-03-22

### Added

- Initial release
- Unit conversion via `convert(value, from:, to:)`
- Length units: km, m, cm, mm, miles, yards, feet, inches
- Weight units: kg, g, mg, lbs, oz
- Temperature units: celsius, fahrenheit, kelvin
- Volume units: liters, ml, gallons, quarts, pints, cups
- Category listing via `categories`
- Unit discovery via `units_for(category)`

[Unreleased]: https://github.com/philiprehberger/rb-metric-units/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/philiprehberger/rb-metric-units/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/philiprehberger/rb-metric-units/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/philiprehberger/rb-metric-units/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/philiprehberger/rb-metric-units/compare/v0.1.4...v0.2.0
[0.1.4]: https://github.com/philiprehberger/rb-metric-units/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/philiprehberger/rb-metric-units/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/philiprehberger/rb-metric-units/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/philiprehberger/rb-metric-units/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/philiprehberger/rb-metric-units/releases/tag/v0.1.0
