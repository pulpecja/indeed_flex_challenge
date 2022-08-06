# frozen_string_literal: true

require 'spec_helper'

describe Validators::ProductValidator do
  describe '#valid?' do
    subject { described_class.new.valid?(product) }

    let(:product) { Product.new(code, name, price) }
    let(:code) { '001' }
    let(:name) { 'Lavender heart' }
    let(:price) { 9.25 }

    context 'for valid params' do
      it { is_expected.to be true }
    end

    context 'for nil code' do
      let(:code) { nil }

      it { is_expected.to be false }
    end

    context 'for empty code' do
      let(:code) { '' }

      it { is_expected.to be false }
    end

    context 'for nil name' do
      let(:name) { nil }

      it { is_expected.to be false }
    end

    context 'for nil price' do
      let(:price) { nil }

      it { is_expected.to be false }
    end

    context 'for string price' do
      let(:price) { 'price' }

      it { is_expected.to be false }
    end

    context 'for price lower than 0' do
      let(:price) { -0.5 }

      it { is_expected.to be false }
    end
  end
end
