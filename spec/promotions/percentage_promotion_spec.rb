# frozen_string_literal: true

require 'spec_helper'

describe Promotions::PercentagePromotion do
  describe '#valid?' do
    subject { described_class.new('minimum_amount', 'percentage_discount').valid? }

    let(:validator) { Validators::Promotions::PercentagePromotionValidator }

    before do
      double = instance_double(validator)
      allow(validator).to receive(:new).and_return(double)
      allow(double).to receive(:valid?).and_return(percentage_promotion_validity)
    end

    context 'for valid validator response' do
      let(:percentage_promotion_validity) { true }

      it { is_expected.to be true }
    end

    context 'for valid validator response' do
      let(:percentage_promotion_validity) { false }

      it { is_expected.to be false }
    end
  end
end
