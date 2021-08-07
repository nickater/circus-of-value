# frozen_string_literal: true

class VendingMachine
  attr_accessor :is_on

  def initialize(items)
    @is_on = true
    @items = items
    @funds = 0.00
    @first_start = true
  end

  def display_products
    puts "#{'Selector'.ljust(10)}#{'Name'.ljust(22)}#{'Price'.ljust(8)} #"
    puts '-' * 42
    @items.each do |item|
      puts "#{item.selector.ljust(10)}#{item.name.ljust(22)}$#{item.price.ljust(8)}#{item.quantity}"
    end
    puts "\n"
  end

  def show_main_menu
    if @first_start
      puts File.readlines('welcome.txt')
      puts "\n\n"
    end
    @first_start = false
    puts "Please make a selection\n#{'-' * 26}\n1) Display All Items\n2) Make a purchase\n3) Add funds - Balance: $#{format(
      '%.2f', @funds
    )}\n4) Exit\n\n"
    gets.chomp
  end

  def purchase_item(selector)
    item_found = false
    item_name = ''
    @items.each_with_index do |item, _index|
      next unless item.selector == selector.upcase

      item_name = item.name
      next unless item.quantity.positive?

      item_found = true
      if @funds >= item.price.to_f
        puts "Purchased #{item.name}!"
        @funds -= item.price.to_f
        item.quantity -= 1
      else
        puts "Sorry, you don\'t have the funds for a #{item.name}"
      end
    end
    return unless item_found == false

    puts "#{item_name} out of stock"
    puts "\n"
  end

  def purchase_handler
    puts 'Enter the selector of the item'
    selector = gets.chomp
    puts `clear`
    purchase_item(selector)
  end

  def handle_user_input(selection)
    case selection
    when '1'
      puts `clear`
      display_products
    when '2'
      purchase_handler
    when '3'
      funds_handler
      puts `clear`
    when '4'
      puts `clear`
      if @funds > 0
         cash_out
      end
      puts 'Good bye!'
      turn_off
    end
  end

  def funds_handler
    puts 'How much would you like to deposit?'
    funds = gets.chomp.to_f
    add_funds(funds)
  end

  def add_funds(money)
    @funds += money
  end

  def cash_out
    quarters = 0
    dimes = 0
    nickels = 0
    pennies = 0
    while format('%.2f', @funds).to_s.to_f >= 0.25
      @funds -= 0.25
      quarters += 1
    end
    while format('%.2f', @funds).to_s.to_f >= 0.10
      @funds -= 0.10
      dimes += 1
    end
    while format('%.2f', @funds).to_s.to_f >= 0.05
      @funds -= 0.05
      nickels += 1
    end
    while format('%.2f', @funds).to_s.to_f.positive?
      @funds -= 0.01
      pennies += 1
    end
    puts "Your change is #{quarters} quarters, #{dimes} dimes, #{nickels} nickels, and #{pennies} pennies"
  end

  def turn_off
    @is_on = false
  end
end
