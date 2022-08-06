# frozen_string_literal: true

require 'spec_helper'

describe Validators::Promotions::PercentagePromotionValidator do
  describe '#valid?' do
    subject { described_class.new.valid?(percentage_promotion) }

    let(:percentage_promotion) { Promotions::PercentagePromotion.new(minimum_amount, percentage_discount) }
    let(:minimum_amount) { 60.0 }
    let(:percentage_discount) { 10.0 }

    context 'for valid params' do
      it { is_expected.to be true }
    end

    context 'for nil minimum_amount' do
      let(:minimum_amount) { nil }

      it { is_expected.to be false }
    end

    context 'for empty minimum_amount' do
      let(:minimum_amount) { '' }

      it { is_expected.to be false }
    end

    context 'for nil percentage_discount' do
      let(:percentage_discount) { nil }

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

    context 'for string percentage_discount' do
      let(:percentage_discount) { 'percentage_discount' }

      it { is_expected.to be false }
    end

    context 'for percentage_discount lower than 0' do
      let(:percentage_discount) { -0.5 }

      it { is_expected.to be false }
    end

    context 'for percentage_discount greater than 100' do
      let(:percentage_discount) { 190.0 }

      it { is_expected.to be false }
    end

    context 'for percentage_discount equal to 100' do
      let(:percentage_discount) { 100.0 }

      it { is_expected.to be true }
    end
  end
end
