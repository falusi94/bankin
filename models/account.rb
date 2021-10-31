# frozen_string_literal: true

class Account
  attr_accessor :user, :bank
  attr_reader :balance

  def initialize(user: nil, balance: nil, bank: nil)
    @user    = user
    @balance = balance
    @bank    = bank
  end

  def apply_change(amount)
    @balance += amount
  end
end
