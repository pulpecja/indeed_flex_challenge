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
  end
end
