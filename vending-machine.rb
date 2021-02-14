# frozen_string_literal: true

class VendingMachine
  attr_accessor :is_on

  def initialize(items)
    @is_on = true
    @items = items
    @funds = 0.00
    @firstStart = true
  end

  def displayProducts
    puts "#{'Selector'.ljust(10)}#{'Name'.ljust(22)}#{'Price'.ljust(8)} #"
    puts '-' * 42
    @items.each do |item|
      puts "#{item.selector.ljust(10)}#{item.name.ljust(22)}$#{item.price.ljust(8)}#{item.quantity}"
    end
    puts "\n"
  end

  def getProduct(index)
    @items[index]
  end

  def showMainMenu
    if @firstStart
      puts File.readlines('welcome.txt')
      puts "\n\n"
    end
    @firstStart = false
    puts "Please make a selection\n#{'-' * 26}\n1) Display All Items\n2) Make a purchase\n3) Add funds - Balance: $#{format(
      '%.2f', @funds
    )}\n4) Exit\n\n"
    gets.chomp
  end

  def purchaseItem(selector)
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
    if item_found == false
      puts "#{item_name} out of stock"
      puts "\n"
    end
  end

  def purchaseHandler
    puts 'Enter the selector of the item'
    selector = gets.chomp
    puts `clear`
    purchaseItem(selector)
  end

  def handleUserInput(selection)
    case selection
    when '1'
      puts `clear`
      displayProducts
    when '2'
      purchaseHandler
    when '3'
      fundsHandler
      puts `clear`
    when '4'
      puts `clear`
      cashOut
      puts 'Good bye!'
      turnOff
    end
  end

  def fundsHandler
    puts 'How much would you like to deposit?'
    funds = gets.chomp.to_f
    addFunds(funds)
  end

  def addFunds(money)
    @funds += money
  end

  def cashOut
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

  def turnOff
    @is_on = false
  end
end
