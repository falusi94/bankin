# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/transfer_agent'
require_relative '../models/bank'
require_relative '../models/account'

class TestTransferAgent < Test::Unit::TestCase
  def setup
    bank = Bank.new(name: 'World Bank')
    account1 = Account.new(user: 'Alice', balance: 3000, bank: bank)
    account2 = Account.new(user: 'Bob', balance: 500, bank: bank)
    account3 = Account.new(user: 'Clark', balance: 800, bank: Bank.new)
    @agent = TransferAgent.new(from: account1, to: account2, amount: 100)
    @inter_bank_agent =
      TransferAgent.new(from: account1, to: account3, amount: 2000, transfer_limit: 1000)
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

  def test_limited_transfer_agent_send_money
    before_balance = @inter_bank_agent.to.balance
    @inter_bank_agent.transfer
    after_balance = @inter_bank_agent.to.balance
    assert_equal 2000, after_balance - before_balance
  end
end
