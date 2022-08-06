# frozen_string_literal: true

require_relative 'validators/product_validator'

class Product
  attr_reader :code, :name, :price

  def initialize(code, name, price)
    @code = code
    @name = name
    @price = price
  end

  def valid?
    Validators::ProductValidator.new.valid?(self)
  end
end
