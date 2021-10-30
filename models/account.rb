# frozen_string_literal: true

class Account
  attr_accessor :user, :balance, :bank

  def initialize(user: nil, balance: nil, bank: nil)
    @user    = user
    @balance = balance
    @bank    = bank
  end
end
