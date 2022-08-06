# frozen_string_literal: true

require 'spec_helper'

describe Validators::Promotions::QuantityPromotionValidator do
  describe '#valid?' do
    subject { described_class.new.valid?(quantity_promotion) }

    let(:quantity_promotion) { Promotions::QuantityPromotion.new(product_code, minimum_amount, discounted_price) }
    let(:product_code) { '001' }
    let(:minimum_amount) { 2 }
    let(:discounted_price) { 8.50 }

    context 'for valid params' do
      it { is_expected.to be true }
    end

    context 'for nil product_code' do
      let(:product_code) { nil }

      it { is_expected.to be false }
    end

    context 'for empty product_code' do
      let(:product_code) { '' }

      it { is_expected.to be false }
    end

    context 'for invalid product_code' do
      let(:product_code) { 'code' }

      it { is_expected.to be false }
    end

    context 'for nil minimum_amount' do
      let(:minimum_amount) { nil }

      it { is_expected.to be false }
    end

    context 'for nil discounted_price' do
      let(:discounted_price) { nil }

      it { is_expected.to be false }
    end

    context 'for string minimum_amount' do
      let(:minimum_amount) { 'minimum_amount' }

      it { is_expected.to be false }
    end

    context 'for minimum_amount lower than 0' do
      let(:minimum_amount) { -1 }

      it { is_expected.to be false }
    end

    context 'for minimum_amount being a float' do
      let(:minimum_amount) { 1.5 }

      it { is_expected.to be false }
    end

    context 'for string discounted_price' do
      let(:discounted_price) { 'discounted_price' }

      it { is_expected.to be false }
    end

    context 'for discounted_price lower than 0' do
      let(:discounted_price) { -0.5 }

      it { is_expected.to be false }
    end
  end
end
