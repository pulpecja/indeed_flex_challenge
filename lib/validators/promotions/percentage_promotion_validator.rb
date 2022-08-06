# frozen_string_literal: true

module Validators
  module Promotions
    class PercentagePromotionValidator < BaseValidator
      def valid?(promotion)
        required_attributes_present?(promotion) &&
          float_and_positive?(promotion.minimum_amount) &&
          float_and_positive?(promotion.percentage_discount) &&
          lower_or_equal_than_100_percent?(promotion.percentage_discount)
      end

      private

      def required_attributes
        %i[minimum_amount percentage_discount]
      end
    end
  end
end
