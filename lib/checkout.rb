# frozen_string_literal: true

class Checkout
  def initialize(promotional_rules)
    @promotional_rules = promotional_rules
  end

  def scan(item); end

  def total; end
end
