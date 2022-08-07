# frozen_string_literal: true

require 'spec_helper'

describe Checkout do
  let(:lavender_heart) { Product.new('001', 'Lavender heart', 9.25) }
  let(:personalised_cufflinks) { Product.new('002', 'Personalised cufflinks', 45.0) }
  let(:kids_tshirt) { Product.new('003', 'Kids T-shirt', 19.95) }

  let(:percentage_promotion) { Promotions::PercentagePromotion.new(60.0, 10.0) }
  let(:quantity_promotion) { Promotions::QuantityPromotion.new('001', 2, 8.5) }

  let(:checkout) { Checkout.new([percentage_promotion, quantity_promotion]) }

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
    context 'with additional promotions' do
      let(:smaller_percentage_promotion) { Promotions::PercentagePromotion.new(20.0, 5.0) }

      let(:checkout) do
        Checkout.new([smaller_percentage_promotion,
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
  end
end
