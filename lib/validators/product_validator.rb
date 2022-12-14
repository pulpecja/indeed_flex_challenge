# frozen_string_literal: true

require_relative '../validators/base_validator'

module Validators
  class ProductValidator < BaseValidator
    def valid?(product)
      required_attributes_present?(product) &&
        float_and_positive?(product.price) &&
        valid_code_format?(product.code)
    end

    private

    def required_attributes
      %i[code name price]
    end
  end
end
