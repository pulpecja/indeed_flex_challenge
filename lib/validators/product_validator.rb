# frozen_string_literal: true

module Validators
  class ProductValidator
    def valid?(product)
      required_attributes_present?(product) &&
        valid_price?(product.price)
    end

    private

    def required_attributes_present?(product)
      required_attributes.each do |attr|
        return false if product.send(attr).nil?
      end

      true
    end

    def required_attributes
      %i[code name price]
    end

    def valid_price?(price)
      price_float?(price) && price.positive?
    end

    def price_float?(price)
      price.is_a? Float
    end
  end
end
