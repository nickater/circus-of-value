#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './vending_item'
require_relative './vending_machine'
require 'csv'

products = []
selector = 0
name = 1
price = 2

CSV.foreach('./products.csv') do |row|
  product = VendingItem.new(row[selector], row[name], row[price])
  products.push(product)
end

vending_machine = VendingMachine.new(products)

while vending_machine.is_on
  selection = vending_machine.show_main_menu
  vending_machine.handle_user_input(selection)
end
