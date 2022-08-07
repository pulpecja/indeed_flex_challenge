# frozen_string_literal: true

require_relative '../validators/promotions/percentage_promotion_validator'

module Promotions
  class PercentagePromotion
    attr_reader :minimum_amount, :percentage_discount

    def initialize(minimum_amount, percentage_discount)
      @minimum_amount = minimum_amount
      @percentage_discount = percentage_discount
    end

    def valid?
      Validators::Promotions::PercentagePromotionValidator.new.valid?(self)
    end

    class << self
      def use_best_promotion(promotions, sum)
        return sum if best_promotion(promotions, sum).nil?

        count_percentage_discount(sum, best_promotion(promotions, sum).percentage_discount).round(2)
      end

      private

      # sort promotions starting with the best for the customer (the highest percentage discount)
      def sorted_best_promotions(promotions)
        promotions.sort_by(&:percentage_discount).reverse
      end

      def best_promotion(promotions, sum)
        sorted_best_promotions(promotions).select { |promo| promo.minimum_amount < sum }.first
      end

      def count_percentage_discount(sum, discount)
        sum * (100.0 - discount) / 100
      end
    end
  end
end
