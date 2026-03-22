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
end
