# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::MetricUnits do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be_nil
  end

  describe '.convert' do
    context 'with length' do
      it 'converts km to miles' do
        result = described_class.convert(1, from: :km, to: :miles)
        expect(result).to be_within(0.001).of(0.621)
      end

      it 'converts miles to km' do
        result = described_class.convert(1, from: :miles, to: :km)
        expect(result).to be_within(0.001).of(1.609)
      end

      it 'converts m to feet' do
        result = described_class.convert(1, from: :m, to: :feet)
        expect(result).to be_within(0.001).of(3.281)
      end

      it 'converts cm to inches' do
        result = described_class.convert(2.54, from: :cm, to: :inches)
        expect(result).to be_within(0.001).of(1.0)
      end

      it 'converts same unit to itself' do
        expect(described_class.convert(5, from: :m, to: :m)).to be_within(0.001).of(5.0)
      end
    end

    context 'with weight' do
      it 'converts kg to lbs' do
        result = described_class.convert(1, from: :kg, to: :lbs)
        expect(result).to be_within(0.01).of(2.205)
      end

      it 'converts lbs to kg' do
        result = described_class.convert(1, from: :lbs, to: :kg)
        expect(result).to be_within(0.001).of(0.454)
      end

      it 'converts g to oz' do
        result = described_class.convert(28.35, from: :g, to: :oz)
        expect(result).to be_within(0.01).of(1.0)
      end

      it 'converts kg to g' do
        expect(described_class.convert(1, from: :kg, to: :g)).to be_within(0.001).of(1000.0)
      end
    end

    context 'with temperature' do
      it 'converts celsius to fahrenheit' do
        expect(described_class.convert(0, from: :celsius, to: :fahrenheit)).to be_within(0.01).of(32.0)
      end

      it 'converts fahrenheit to celsius' do
        expect(described_class.convert(212, from: :fahrenheit, to: :celsius)).to be_within(0.01).of(100.0)
      end

      it 'converts celsius to kelvin' do
        expect(described_class.convert(0, from: :celsius, to: :kelvin)).to be_within(0.01).of(273.15)
      end

      it 'converts kelvin to celsius' do
        expect(described_class.convert(273.15, from: :kelvin, to: :celsius)).to be_within(0.01).of(0.0)
      end

      it 'converts fahrenheit to kelvin' do
        expect(described_class.convert(32, from: :fahrenheit, to: :kelvin)).to be_within(0.01).of(273.15)
      end

      it 'converts same temperature unit' do
        expect(described_class.convert(100, from: :celsius, to: :celsius)).to be_within(0.01).of(100.0)
      end
    end

    context 'with volume' do
      it 'converts liters to gallons' do
        result = described_class.convert(3.785, from: :liters, to: :gallons)
        expect(result).to be_within(0.01).of(1.0)
      end

      it 'converts ml to liters' do
        expect(described_class.convert(1000, from: :ml, to: :liters)).to be_within(0.001).of(1.0)
      end

      it 'converts cups to ml' do
        result = described_class.convert(1, from: :cups, to: :ml)
        expect(result).to be_within(1).of(236.6)
      end
    end

    context 'with speed' do
      it 'converts km/h to mph' do
        result = described_class.convert(100, from: :kilometers_per_hour, to: :miles_per_hour)
        expect(result).to be_within(0.1).of(62.14)
      end

      it 'converts m/s to knots' do
        result = described_class.convert(10, from: :meters_per_second, to: :knots)
        expect(result).to be_within(0.1).of(19.44)
      end

      it 'converts mph to feet_per_second' do
        result = described_class.convert(60, from: :miles_per_hour, to: :feet_per_second)
        expect(result).to be_within(0.1).of(88.0)
      end

      it 'converts knots to km/h' do
        result = described_class.convert(1, from: :knots, to: :kilometers_per_hour)
        expect(result).to be_within(0.01).of(1.852)
      end
    end

    context 'with pressure' do
      it 'converts psi to bar' do
        result = described_class.convert(14.5, from: :psi, to: :bar)
        expect(result).to be_within(0.01).of(1.0)
      end

      it 'converts atm to kpa' do
        result = described_class.convert(1, from: :atmospheres, to: :kilopascals)
        expect(result).to be_within(0.01).of(101.325)
      end

      it 'converts bar to pascals' do
        result = described_class.convert(1, from: :bar, to: :pascals)
        expect(result).to be_within(0.01).of(100_000.0)
      end

      it 'converts mmhg to atmospheres' do
        result = described_class.convert(760, from: :mmhg, to: :atmospheres)
        expect(result).to be_within(0.01).of(1.0)
      end
    end

    context 'with energy' do
      it 'converts calories to joules' do
        result = described_class.convert(1, from: :calories, to: :joules)
        expect(result).to be_within(0.01).of(4.184)
      end

      it 'converts kwh to btu' do
        result = described_class.convert(1, from: :kilowatt_hours, to: :btu)
        expect(result).to be_within(1).of(3412.14)
      end

      it 'converts kilocalories to kilojoules' do
        result = described_class.convert(1, from: :kilocalories, to: :kilojoules)
        expect(result).to be_within(0.01).of(4.184)
      end

      it 'converts watt_hours to joules' do
        result = described_class.convert(1, from: :watt_hours, to: :joules)
        expect(result).to be_within(0.01).of(3600.0)
      end
    end

    context 'with errors' do
      it 'raises for non-numeric value' do
        expect { described_class.convert('5', from: :km, to: :m) }.to raise_error(described_class::Error)
      end

      it 'raises for unknown units' do
        expect { described_class.convert(5, from: :parsecs, to: :m) }.to raise_error(described_class::Error)
      end

      it 'raises for incompatible units' do
        expect { described_class.convert(5, from: :km, to: :kg) }.to raise_error(described_class::Error)
      end
    end
  end

  describe '.categories' do
    it 'returns all categories' do
      expect(described_class.categories).to eq(%i[length weight volume temperature speed pressure energy])
    end

    it 'includes speed category' do
      expect(described_class.categories).to include(:speed)
    end

    it 'includes pressure category' do
      expect(described_class.categories).to include(:pressure)
    end

    it 'includes energy category' do
      expect(described_class.categories).to include(:energy)
    end
  end

  describe '.units_for' do
    it 'returns length units' do
      expect(described_class.units_for(:length)).to eq(%i[km m cm mm miles yards feet inches])
    end

    it 'returns weight units' do
      expect(described_class.units_for(:weight)).to eq(%i[kg g mg lbs oz])
    end

    it 'returns temperature units' do
      expect(described_class.units_for(:temperature)).to eq(%i[celsius fahrenheit kelvin])
    end

    it 'returns volume units' do
      expect(described_class.units_for(:volume)).to eq(%i[liters ml gallons quarts pints cups])
    end

    it 'returns speed units' do
      expect(described_class.units_for(:speed)).to eq(%i[meters_per_second kilometers_per_hour miles_per_hour knots feet_per_second])
    end

    it 'returns pressure units' do
      expect(described_class.units_for(:pressure)).to eq(%i[pascals kilopascals bar psi atmospheres mmhg])
    end

    it 'returns energy units' do
      expect(described_class.units_for(:energy)).to eq(%i[joules kilojoules calories kilocalories watt_hours kilowatt_hours btu])
    end

    it 'raises for unknown category' do
      expect { described_class.units_for(:frequency) }.to raise_error(described_class::Error)
    end

    it 'accepts string category' do
      expect(described_class.units_for('length')).to eq(%i[km m cm mm miles yards feet inches])
    end
  end

  describe 'roundtrip conversion accuracy' do
    it 'km -> miles -> km is accurate' do
      result = described_class.convert(
        described_class.convert(10, from: :km, to: :miles),
        from: :miles, to: :km
      )
      expect(result).to be_within(0.001).of(10.0)
    end

    it 'celsius -> fahrenheit -> celsius is accurate' do
      result = described_class.convert(
        described_class.convert(37.0, from: :celsius, to: :fahrenheit),
        from: :fahrenheit, to: :celsius
      )
      expect(result).to be_within(0.001).of(37.0)
    end

    it 'kg -> lbs -> kg is accurate' do
      result = described_class.convert(
        described_class.convert(5, from: :kg, to: :lbs),
        from: :lbs, to: :kg
      )
      expect(result).to be_within(0.001).of(5.0)
    end

    it 'liters -> gallons -> liters is accurate' do
      result = described_class.convert(
        described_class.convert(3, from: :liters, to: :gallons),
        from: :gallons, to: :liters
      )
      expect(result).to be_within(0.001).of(3.0)
    end

    it 'km/h -> mph -> km/h is accurate' do
      result = described_class.convert(
        described_class.convert(120, from: :kilometers_per_hour, to: :miles_per_hour),
        from: :miles_per_hour, to: :kilometers_per_hour
      )
      expect(result).to be_within(0.001).of(120.0)
    end

    it 'psi -> bar -> psi is accurate' do
      result = described_class.convert(
        described_class.convert(30, from: :psi, to: :bar),
        from: :bar, to: :psi
      )
      expect(result).to be_within(0.001).of(30.0)
    end

    it 'calories -> joules -> calories is accurate' do
      result = described_class.convert(
        described_class.convert(100, from: :calories, to: :joules),
        from: :joules, to: :calories
      )
      expect(result).to be_within(0.001).of(100.0)
    end
  end

  describe 'zero value conversion' do
    it 'converts zero km to zero miles' do
      expect(described_class.convert(0, from: :km, to: :miles)).to eq(0.0)
    end

    it 'converts zero celsius to 32 fahrenheit' do
      expect(described_class.convert(0, from: :celsius, to: :fahrenheit)).to be_within(0.01).of(32.0)
    end

    it 'converts zero kg to zero lbs' do
      expect(described_class.convert(0, from: :kg, to: :lbs)).to eq(0.0)
    end

    it 'converts zero m/s to zero km/h' do
      expect(described_class.convert(0, from: :meters_per_second, to: :kilometers_per_hour)).to eq(0.0)
    end

    it 'converts zero pascals to zero bar' do
      expect(described_class.convert(0, from: :pascals, to: :bar)).to eq(0.0)
    end

    it 'converts zero joules to zero calories' do
      expect(described_class.convert(0, from: :joules, to: :calories)).to eq(0.0)
    end
  end

  describe 'negative values' do
    it 'converts negative celsius to fahrenheit' do
      expect(described_class.convert(-40, from: :celsius, to: :fahrenheit)).to be_within(0.01).of(-40.0)
    end

    it 'converts negative length values' do
      result = described_class.convert(-5, from: :km, to: :m)
      expect(result).to be_within(0.001).of(-5000.0)
    end

    it 'converts negative speed values' do
      result = described_class.convert(-100, from: :kilometers_per_hour, to: :miles_per_hour)
      expect(result).to be_within(0.1).of(-62.14)
    end
  end

  describe 'very large and small values' do
    it 'converts a very large distance' do
      result = described_class.convert(1_000_000, from: :km, to: :m)
      expect(result).to be_within(0.001).of(1_000_000_000.0)
    end

    it 'converts a very small weight' do
      result = described_class.convert(0.001, from: :mg, to: :g)
      expect(result).to be_within(0.000001).of(0.000001)
    end
  end

  describe 'additional unit conversions' do
    it 'converts yards to feet' do
      expect(described_class.convert(1, from: :yards, to: :feet)).to be_within(0.001).of(3.0)
    end

    it 'converts quarts to pints' do
      expect(described_class.convert(1, from: :quarts, to: :pints)).to be_within(0.01).of(2.0)
    end

    it 'converts kelvin to fahrenheit' do
      expect(described_class.convert(373.15, from: :kelvin, to: :fahrenheit)).to be_within(0.01).of(212.0)
    end

    it 'converts mg to kg' do
      expect(described_class.convert(1_000_000, from: :mg, to: :kg)).to be_within(0.001).of(1.0)
    end

    it 'converts inches to cm' do
      expect(described_class.convert(1, from: :inches, to: :cm)).to be_within(0.001).of(2.54)
    end
  end

  describe 'string unit arguments' do
    it 'accepts string units' do
      result = described_class.convert(1, from: 'km', to: 'm')
      expect(result).to be_within(0.001).of(1000.0)
    end

    it 'accepts string units for speed' do
      result = described_class.convert(100, from: 'kilometers_per_hour', to: 'miles_per_hour')
      expect(result).to be_within(0.1).of(62.14)
    end
  end

  describe '.abbreviation' do
    it 'returns abbreviation for length units' do
      expect(described_class.abbreviation(:km)).to eq('km')
      expect(described_class.abbreviation(:miles)).to eq('mi')
      expect(described_class.abbreviation(:feet)).to eq('ft')
    end

    it 'returns abbreviation for weight units' do
      expect(described_class.abbreviation(:kg)).to eq('kg')
      expect(described_class.abbreviation(:lbs)).to eq('lb')
    end

    it 'returns abbreviation for temperature units' do
      expect(described_class.abbreviation(:celsius)).to eq("\u00B0C")
      expect(described_class.abbreviation(:fahrenheit)).to eq("\u00B0F")
      expect(described_class.abbreviation(:kelvin)).to eq('K')
    end

    it 'returns abbreviation for speed units' do
      expect(described_class.abbreviation(:meters_per_second)).to eq('m/s')
      expect(described_class.abbreviation(:kilometers_per_hour)).to eq('km/h')
      expect(described_class.abbreviation(:miles_per_hour)).to eq('mph')
      expect(described_class.abbreviation(:knots)).to eq('kn')
    end

    it 'returns abbreviation for pressure units' do
      expect(described_class.abbreviation(:pascals)).to eq('Pa')
      expect(described_class.abbreviation(:bar)).to eq('bar')
      expect(described_class.abbreviation(:psi)).to eq('psi')
      expect(described_class.abbreviation(:atmospheres)).to eq('atm')
      expect(described_class.abbreviation(:mmhg)).to eq('mmHg')
    end

    it 'returns abbreviation for energy units' do
      expect(described_class.abbreviation(:joules)).to eq('J')
      expect(described_class.abbreviation(:kilowatt_hours)).to eq('kWh')
      expect(described_class.abbreviation(:btu)).to eq('BTU')
      expect(described_class.abbreviation(:calories)).to eq('cal')
    end

    it 'returns abbreviation for volume units' do
      expect(described_class.abbreviation(:liters)).to eq('L')
      expect(described_class.abbreviation(:ml)).to eq('mL')
      expect(described_class.abbreviation(:gallons)).to eq('gal')
    end

    it 'accepts string unit names' do
      expect(described_class.abbreviation('kg')).to eq('kg')
    end

    it 'returns nil for unknown unit' do
      expect(described_class.abbreviation(:parsecs)).to be_nil
    end
  end

  describe '.format' do
    it 'formats with default precision' do
      expect(described_class.format(3.14159, :kg)).to eq('3.14 kg')
    end

    it 'formats with custom precision' do
      expect(described_class.format(3.14159, :kg, precision: 4)).to eq('3.1416 kg')
    end

    it 'formats with precision 0' do
      expect(described_class.format(3.7, :m, precision: 0)).to eq('4 m')
    end

    it 'formats speed units' do
      expect(described_class.format(100.5, :kilometers_per_hour)).to eq('100.5 km/h')
    end

    it 'formats pressure units' do
      expect(described_class.format(1013.25, :pascals, precision: 1)).to eq('1013.3 Pa')
    end

    it 'formats energy units' do
      expect(described_class.format(2500.0, :kilocalories, precision: 0)).to eq('2500 kcal')
    end

    it 'formats zero values' do
      expect(described_class.format(0, :kg)).to eq('0 kg')
    end

    it 'formats negative values' do
      expect(described_class.format(-10.5, :celsius)).to eq("-10.5 \u00B0C")
    end

    it 'raises for unknown unit' do
      expect { described_class.format(1, :parsecs) }.to raise_error(described_class::Error, /unknown unit abbreviation/)
    end

    it 'raises for non-numeric value' do
      expect { described_class.format('five', :kg) }.to raise_error(described_class::Error, /numeric/)
    end

    it 'accepts string unit names' do
      expect(described_class.format(5.0, 'km')).to eq('5.0 km')
    end
  end

  describe 'error messages' do
    it 'includes the unknown unit name in error' do
      expect { described_class.convert(1, from: :parsecs, to: :m) }.to raise_error(described_class::Error, /parsecs/)
    end

    it 'raises for non-numeric input' do
      expect { described_class.convert('five', from: :km, to: :m) }.to raise_error(described_class::Error, /numeric/)
    end

    it 'raises for incompatible categories' do
      expect { described_class.convert(1, from: :kg, to: :m) }.to raise_error(described_class::Error, /cannot convert/)
    end
  end
end
