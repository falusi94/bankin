# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/transfer_agent'
require_relative '../models/bank'
require_relative '../models/account'

class TestTransferAgent < Test::Unit::TestCase
  def setup
    bank = Bank.new(name: 'World Bank')
    account1 = Account.new(user: 'Alice', balance: 1000, bank: bank)
    account2 = Account.new(user: 'Bob', balance: 500, bank: bank)
    @agent = TransferAgent.new(from: account1, to: account2, amount: 100)
  end

  def test_bank_init_parameters_set_properly
    transfer_agent =
      TransferAgent.new(from: 'account1', to: 'account2', amount: 500, transfer_limit: 1500)
    assert_equal 'account1', transfer_agent.from
    assert_equal 'account2', transfer_agent.to
    assert_equal 500, transfer_agent.amount
    assert_equal 1500, transfer_agent.transfer_limit
  end

  def test_transfer_agent_send_money
    assert_equal true, @agent.transfer
  end
end
