# frozen_string_literal: true

module Validators
  module Promotions
    class QuantityPromotionValidator < BaseValidator
      def valid?(promotion)
        required_attributes_present?(promotion) &&
          integer_and_positive?(promotion.minimum_amount) &&
          float_and_positive?(promotion.discounted_price)
      end

      private

      def required_attributes
        %i[product_code minimum_amount discounted_price]
      end
    end
  end
end
