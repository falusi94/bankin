# frozen_string_literal: true

require_relative 'models/account'
require_relative 'models/bank'
require_relative 'models/transfer'

class ShowMeTheMoney
  def initialize
    @bank_a = Bank.new(name: 'A')
    @bank_b = Bank.new(name: 'B')
    @jims_account = Account.new(user: 'Jim', balance: 25_000, bank: @bank_a)
    @emmas_account = Account.new(user: 'Emma', balance: 15_000, bank: @bank_b)
  end
end
