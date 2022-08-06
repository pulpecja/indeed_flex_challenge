# frozen_string_literal: true

require_relative 'validators/promotions/quantity_promotion_validator'

module Promotions
  class QuantityPromotion
    attr_reader :product_code, :minimum_amount, :discounted_price

    def initialize(product_code, minimum_amount, discounted_price)
      @product_code = product_code
      @minimum_amount = minimum_amount
      @discounted_price = discounted_price
    end

    def valid?
      Validators::Promotions::QuantityPromotion.new.valid?(self)
    end
  end
end
