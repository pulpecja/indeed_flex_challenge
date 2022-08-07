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
    @sum = items_prices_sum
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
      attributes[:price] = Promotions::QuantityPromotion.find_best_price(
        quantity_promotions,
        code,
        attributes[:amount],
        attributes[:price]
      )
    end
  end

  def add_percentage_promotion
    Promotions::PercentagePromotion.use_best_promotion(percentage_promotions, @sum)
  end

  def items_prices_sum
    @basket.values.sum { |v| v[:amount] * v[:price] }
  end

  def quantity_promotions
    select_promotions(Promotions::QuantityPromotion)
  end

  def percentage_promotions
    select_promotions(Promotions::PercentagePromotion)
  end

  def select_promotions(klass_name)
    @promotional_rules.select { |promo| promo.instance_of?(klass_name) }
  end

  def validate_promotional_rules
    raise InvalidPromotionError unless @promotional_rules.all?(&:valid?)
  end
end
