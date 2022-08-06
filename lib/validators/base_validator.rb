# frozen_string_literal: true

module Validators
  class BaseValidator
    private

    def required_attributes_present?(product)
      required_attributes.each do |attr|
        return false if product.send(attr).nil? || product.send(attr) == ''
      end

      true
    end

    def float_and_positive?(attr)
      return false unless attr.is_a? Float

      attr.positive?
    end

    def integer_and_positive?(attr)
      return false unless attr.is_a? Integer

      attr.positive?
    end

    def lower_or_equal_than_100_percent?(percent)
      percent <= 100
    end
  end
end
