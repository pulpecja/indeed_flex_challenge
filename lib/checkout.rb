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
      @sum += (attributes[:amount] * attributes[:price])
    end
    add_percentage_promotion
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
    @basket[item.code] = { amount: 1, price: item.price }
  end

  def add_item(item)
    @basket[item.code][:amount] += 1
  end

  def add_quantity_promotions
    @basket.each do |code, attributes|
      next if best_quantity_promotions[code].nil?

      best_quantity_promotions[code].each do |promotion|
        next if promotion.minimum_amount > attributes[:amount]

        attributes[:price] = promotion.discounted_price
        break
      end
    end
  end

  def add_percentage_promotion
    best_percentage_promotions.each do |promotion|
      next if promotion.minimum_amount > @sum

      @sum = count_percentage_discount(promotion.percentage_discount)
      break
    end

    @sum.round(2)
  end

  # sort promotions starting with the best for the customer (the highest discount)
  def best_percentage_promotions
    select_promotions(Promotions::PercentagePromotion).sort_by(&:percentage_discount).reverse
  end

  def best_quantity_promotions
    select_promotions(Promotions::QuantityPromotion).sort_by(&:discounted_price).group_by(&:product_code)
  end

  def count_percentage_discount(discount)
    @sum * (100.0 - discount) / 100
  end

  def select_promotions(klass_name)
    @promotional_rules.select { |promo| promo.instance_of?(klass_name) }
  end
end
