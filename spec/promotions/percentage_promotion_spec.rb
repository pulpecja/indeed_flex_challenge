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

  describe '#use_best_promotion' do
    subject(:use_best_promotion) { described_class.use_best_promotion(promotions, sum) }

    let(:percent_promotion10) { Promotions::PercentagePromotion.new(50.00, 10) }
    let(:percent_promotion20) { Promotions::PercentagePromotion.new(60.00, 20) }
    let(:percent_promotion30) { Promotions::PercentagePromotion.new(70.00, 30) }
    let(:promotions) { [percent_promotion10, percent_promotion20, percent_promotion30] }
    let(:sum) { 62 }

    context 'when couple promotions are valid' do
      it { is_expected.to eq 49.60 }
    end

    context 'when no promotion is valid' do
      let(:sum) { 40 }

      it { is_expected.to eq sum }
    end
  end
end
