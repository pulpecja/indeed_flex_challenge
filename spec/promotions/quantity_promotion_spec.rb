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
end
