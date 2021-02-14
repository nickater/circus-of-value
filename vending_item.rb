# frozen_string_literal: true

class VendingItem
  attr_accessor :selector, :name, :price, :quantity

  def initialize(selector, name, price)
    @selector = selector
    @name = name
    @price = price
    @quantity = 5
  end
end
