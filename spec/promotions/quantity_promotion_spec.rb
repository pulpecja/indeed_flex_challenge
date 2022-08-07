# frozen_string_literal: true

require 'spec_helper'

describe Promotions::QuantityPromotion do
  describe '#valid?' do
    subject { described_class.new('product_code', 'minimum_amount', 'discounted_price').valid? }

    let(:validator) { Validators::Promotions::QuantityPromotionValidator }

    before do
      double = instance_double(validator)
      allow(validator).to receive(:new).and_return(double)
      allow(double).to receive(:valid?).and_return(quantity_promotion_validity)
    end

    context 'for valid validator response' do
      let(:quantity_promotion_validity) { true }

      it { is_expected.to be true }
    end

    context 'for valid validator response' do
      let(:quantity_promotion_validity) { false }

      it { is_expected.to be false }
    end
  end

  describe '#find_best_price' do
    subject(:find_best_price) { described_class.find_best_price(promotions, '001', amount, 3.50) }

    let(:promotion_for2) { Promotions::QuantityPromotion.new('001', 2, 3.00) }
    let(:promotion_for3) { Promotions::QuantityPromotion.new('001', 3, 2.50) }
    let(:promotion_for4) { Promotions::QuantityPromotion.new('001', 4, 2.00) }
    let(:promotions) { [promotion_for2, promotion_for3, promotion_for4] }
    let(:amount) { 3 }

    context 'when couple promotions are valid' do
      it { is_expected.to eq 2.50 }
    end

    context 'when no promotion is valid' do
      let(:amount) { 1 }

      it { is_expected.to eq 3.50 }
    end
  end
end
