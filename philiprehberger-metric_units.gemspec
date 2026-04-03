# frozen_string_literal: true

require_relative 'lib/philiprehberger/metric_units/version'

Gem::Specification.new do |spec|
  spec.name = 'philiprehberger-metric_units'
  spec.version = Philiprehberger::MetricUnits::VERSION
  spec.authors = ['Philip Rehberger']
  spec.email = ['me@philiprehberger.com']

  spec.summary = 'Unit conversion for length, weight, temperature, volume, speed, pressure, and energy measurements'
  spec.description = 'Unit conversion library supporting length, weight, temperature, volume, speed, pressure, ' \
                     'and energy categories with a simple convert API, unit abbreviations, and formatted output.'
  spec.homepage = 'https://philiprehberger.com/open-source-packages/ruby/philiprehberger-metric_units'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/philiprehberger/rb-metric-units'
  spec.metadata['changelog_uri'] = 'https://github.com/philiprehberger/rb-metric-units/blob/main/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/philiprehberger/rb-metric-units/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
