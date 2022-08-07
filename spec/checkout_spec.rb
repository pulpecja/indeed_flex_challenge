# frozen_string_literal: true

require 'spec_helper'

describe Checkout do
  let(:lavender_heart) { Product.new('001', 'Lavender heart', 9.25) }
  let(:personalised_cufflinks) { Product.new('002', 'Personalised cufflinks', 45.0) }
  let(:kids_tshirt) { Product.new('003', 'Kids T-shirt', 19.95) }

  let(:percentage_promotion) { Promotions::PercentagePromotion.new(60.0, 10.0) }
  let(:quantity_promotion) { Promotions::QuantityPromotion.new('001', 2, 8.5) }

  let(:checkout) { Checkout.new([percentage_promotion, quantity_promotion]) }

  describe '#initialize' do
    subject(:create_checkout) { checkout }

    shared_examples 'raises InvalidPromotionError' do
      it 'raises InvalidPromotionError' do
        expect { create_checkout }.to raise_error Checkout::InvalidPromotionError
      end
    end

    context 'for invalid quantity promotion' do
      before { allow(quantity_promotion).to receive(:valid?).and_return(false) }

      include_examples 'raises InvalidPromotionError'
    end

    context 'for invalid percentage promotion' do
      before { allow(percentage_promotion).to receive(:valid?).and_return(false) }

      include_examples 'raises InvalidPromotionError'
    end
  end

  describe '#scan' do
    subject(:scan_item) { checkout.scan(lavender_heart) }

    context 'for invalid product' do
      let(:validator) { Validators::ProductValidator }

      before do
        double = instance_double(validator)
        allow(validator).to receive(:new).and_return(double)
        allow(double).to receive(:valid?).with(lavender_heart).and_return(false)
      end

      it 'raises error' do
        expect { scan_item }.to raise_error Checkout::InvalidProductError
      end
    end
  end

  describe 'total' do
    # tests from the requirements
    context 'for 001, 002 and 003 items' do
      it 'counts promotions and returns total price' do
        checkout.scan(lavender_heart)
        checkout.scan(personalised_cufflinks)
        checkout.scan(kids_tshirt)
        expect(checkout.total).to eq 66.78
      end
    end

    context 'for 001, 003 and 001 items' do
      it 'counts promotions and returns total price' do
        checkout.scan(lavender_heart)
        checkout.scan(kids_tshirt)
        checkout.scan(lavender_heart)
        expect(checkout.total).to eq 36.95
      end
    end

    context 'for 001, 002, 001 and 003 items' do
      it 'counts promotions and returns total price' do
        checkout.scan(lavender_heart)
        checkout.scan(personalised_cufflinks)
        checkout.scan(lavender_heart)
        checkout.scan(kids_tshirt)
        expect(checkout.total).to eq 73.76
      end
    end

    # additional tests
    context 'with additional percentage promotion' do
      let(:lower_percentage_promotion) { Promotions::PercentagePromotion.new(20.0, 5.0) }

      let(:checkout) do
        Checkout.new([lower_percentage_promotion,
                      percentage_promotion,
                      quantity_promotion])
      end

      it 'counts promotions and returns total price' do
        checkout.scan(lavender_heart)
        checkout.scan(personalised_cufflinks)
        checkout.scan(kids_tshirt)
        expect(checkout.total).to eq 66.78
      end
    end

    context 'with additional quantity promotion' do
      let(:better_quantity_promotion) { Promotions::QuantityPromotion.new('001', 3, 8.0) }

      let(:checkout) do
        Checkout.new([percentage_promotion,
                      better_quantity_promotion,
                      quantity_promotion])
      end

      it 'counts promotions and returns total price' do
        checkout.scan(lavender_heart)
        checkout.scan(kids_tshirt)
        checkout.scan(lavender_heart)
        checkout.scan(lavender_heart)
        expect(checkout.total).to eq 43.95
      end
    end

    context 'with quantity promotions for multiple items' do
      let(:better_lavender_heart_promotion) { Promotions::QuantityPromotion.new('001', 3, 8.0) }
      let(:tshirt_promotion) { Promotions::QuantityPromotion.new('003', 2, 18.0) }
      let(:better_tshirt_promotion) { Promotions::QuantityPromotion.new('003', 3, 17.0) }

      let(:checkout) do
        Checkout.new([percentage_promotion,
                      better_lavender_heart_promotion,
                      quantity_promotion,
                      tshirt_promotion,
                      better_tshirt_promotion])
      end

      it 'counts promotions and returns total price' do
        4.times { checkout.scan(lavender_heart) }
        3.times { checkout.scan(kids_tshirt) }
        expect(checkout.total).to eq 74.7
      end
    end
  end
end
