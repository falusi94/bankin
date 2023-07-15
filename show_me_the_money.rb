# frozen_string_literal: true

require_relative 'boot'

class ShowMeTheMoney
  attr_reader :jims_account, :emmas_account, :bank_a, :bank_b

  def initialize
    @bank_a = Bank.new(name: 'A')
    @bank_b = Bank.new(name: 'B')
    @jims_account = Account.new(user: 'Jim', balance: 25_000, bank: @bank_a)
    @emmas_account = Account.new(user: 'Emma', balance: 15_000, bank: @bank_b)
  end

  def run
    puts jims_account
    puts emmas_account

    agent = TransferAgent.new(origin: jims_account, destination: emmas_account,
                              amount: 20_000, transfer_limit: 1000)

    transfers = agent.make_transfer
    puts "Transfers\n---------"
    transfers.each { |transfer| TransferLogger.info(transfer) }

    puts jims_account
    puts emmas_account
  end
end
