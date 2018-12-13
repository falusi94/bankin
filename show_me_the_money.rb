# frozen_string_literal: true

require_relative 'models/account'
require_relative 'models/bank'
require_relative 'models/transfer'

class ShowMeThwMoney
  def initialize
    @bank_a = Bank.new(name: 'A')
    @bank_b = Bank.new(name: 'B')
    @jims_account = Account.new(user: 'Jim', balance: 25000, bank: @bank_a)
    @emmas_account = Account.new(user: 'Emma', balance: 15000, bank: @bank_b)
  end
end
