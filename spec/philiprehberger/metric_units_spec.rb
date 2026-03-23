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
      expect(described_class.categories).to eq(%i[length weight volume temperature])
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

    it 'raises for unknown category' do
      expect { described_class.units_for(:speed) }.to raise_error(described_class::Error)
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
  end

  describe 'negative values' do
    it 'converts negative celsius to fahrenheit' do
      expect(described_class.convert(-40, from: :celsius, to: :fahrenheit)).to be_within(0.01).of(-40.0)
    end

    it 'converts negative length values' do
      result = described_class.convert(-5, from: :km, to: :m)
      expect(result).to be_within(0.001).of(-5000.0)
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
