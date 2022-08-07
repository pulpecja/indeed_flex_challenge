# frozen_string_literal: true

require_relative '../validators/promotions/quantity_promotion_validator'

module Promotions
  class QuantityPromotion
    attr_reader :product_code, :minimum_amount, :discounted_price

    def initialize(product_code, minimum_amount, discounted_price)
      @product_code = product_code
      @minimum_amount = minimum_amount
      @discounted_price = discounted_price
    end

    def valid?
      Validators::Promotions::QuantityPromotionValidator.new.valid?(self)
    end

    class << self
      def find_best_price(promotions, code, amount, price)
        return price if best_promotion(promotions, code, amount).nil?

        best_promotion(promotions, code, amount).discounted_price
      end

      private

      # sort promotions starting with the best for the customer (the lowest price) and group by the code
      def sorted_best_promotions(promotions)
        promotions.sort_by(&:discounted_price).group_by(&:product_code)
      end

      def best_promotion(promotions, code, amount)
        return nil if sorted_best_promotions(promotions)[code].nil?

        sorted_best_promotions(promotions)[code].select { |promo| promo.minimum_amount <= amount }.first
      end
    end
  end
end
