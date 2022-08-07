# frozen_string_literal: true

require 'pry'

class Checkout
  class InvalidProductError < StandardError; end
  class InvalidPromotionError < StandardError; end

  def initialize(promotional_rules)
    @promotional_rules = promotional_rules
    @basket = {}
    @sum = 0.0

    validate_promotional_rules
  end

  def scan(item)
    raise InvalidProductError unless item.valid?

    add_item_do_basket(item)
  end

  def total
    add_quantity_promotions
    @sum = sum_items_prices
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

      best_promotion = best_quantity_promotions[code].select do |promo|
        promo.minimum_amount <= attributes[:amount]
      end.first
      next if best_promotion.nil?

      attributes[:price] = best_promotion.discounted_price
    end
  end

  def sum_items_prices
    @basket.values.sum { |v| v[:amount] * v[:price] }
  end

  def add_percentage_promotion
    best_promotion = best_percentage_promotions.select { |promo| promo.minimum_amount < @sum }.first
    return @sum if best_promotion.nil?

    @sum = count_percentage_discount(best_promotion.percentage_discount).round(2)
  end

  # sort promotions starting with the best for the customer (the highest discount)
  def best_percentage_promotions
    select_promotions(Promotions::PercentagePromotion).sort_by(&:percentage_discount).reverse
  end

  # sort promotions starting with the best for the customer (the lowest price) and group by the code
  def best_quantity_promotions
    select_promotions(Promotions::QuantityPromotion).sort_by(&:discounted_price).group_by(&:product_code)
  end

  def count_percentage_discount(discount)
    @sum * (100.0 - discount) / 100
  end

  def select_promotions(klass_name)
    @promotional_rules.select { |promo| promo.instance_of?(klass_name) }
  end

  def validate_promotional_rules
    raise InvalidPromotionError unless @promotional_rules.all?(&:valid?)
  end
end
