# frozen_string_literal: true

require_relative 'models/account'
require_relative 'models/bank'
require_relative 'models/transfer'
require_relative 'lib/transfer_agent'

class ShowMeTheMoney
  attr_reader :jims_account, :emmas_account
  def initialize
    @bank_a = Bank.new(name: 'A')
    @bank_b = Bank.new(name: 'B')
    @jims_account = Account.new(user: 'Jim', balance: 25_000, bank: @bank_a)
    @emmas_account = Account.new(user: 'Emma', balance: 15_000, bank: @bank_b)
  end

  def run
    agent = TransferAgent.new(from: jims_account, to: emmas_account,
                              amount: 20_000, transfer_limit: 1000)
    agent.transfer
  end
end
