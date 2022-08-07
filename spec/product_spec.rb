# frozen_string_literal: true

require 'spec_helper'

describe Product do
  describe '#valid?' do
    subject { described_class.new('code', 'name', 'price').valid? }

    let(:validator) { Validators::ProductValidator }

    before do
      double = instance_double(validator)
      allow(validator).to receive(:new).and_return(double)
      allow(double).to receive(:valid?).and_return(product_validity)
    end

    context 'for valid validator response' do
      let(:product_validity) { true }

      it { is_expected.to be true }
    end

    context 'for valid validator response' do
      let(:product_validity) { false }

      it { is_expected.to be false }
    end
  end
end
