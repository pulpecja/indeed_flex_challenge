# frozen_string_literal: true

require 'pry'

class Checkout
  def initialize(promotional_rules)
    @promotional_rules = promotional_rules
    @basket = {}
    @sum = 0.0
  end

  def scan(item)
    add_item_do_basket(item)
  end

  def total
    add_quantity_promotions

    @basket.each do |_code, attributes|
      @sum += (attributes[0] * attributes[1])
    end
    add_percentage_promotions
  end

  private

  def add_item_do_basket(item)
    if @basket[item.code].nil?
      create_item(item)
    else
      add_item(item)
    end
  end

  def create_item(item)
    @basket[item.code] = [1, item.price]
  end

  def add_item(item)
    @basket[item.code][0] += 1
  end

  def add_quantity_promotions
    quantity_promotions = extract_promotions(Promotions::QuantityPromotion)

    quantity_promotions.each do |promotion|
      discounted_product_code = @basket[promotion.product_code]
      next if promotion.minimum_amount > discounted_product_code[0]

      discounted_product_code[1] = promotion.discounted_price
    end
  end

  def add_percentage_promotions
    percentage_promotions = extract_promotions(Promotions::PercentagePromotion)

    percentage_promotions.each do |promotion|
      next if promotion.minimum_amount > @sum

      @sum = @sum * (100.0 - promotion.percentage_discount) / 100
    end
    @sum.round(2)
  end

  def extract_promotions(klass_name)
    @promotional_rules.select { |promo| promo.instance_of?(klass_name) }
  end
end
