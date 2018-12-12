# frozen_string_literal: true

require 'test/unit'
require 'timecop'
require_relative '../models/transfer'
require_relative '../models/bank'
require_relative '../models/account'

class TestTransfer < Test::Unit::TestCase
  def setup
    bank = Bank.new(name: 'World Bank')
    account1 = Account.new(user: 'Alice', balance: 1000, bank: bank)
    account2 = Account.new(user: 'Bob', balance: 500, bank: bank)
    @transfer = Transfer.new(from: account1, to: account2, amount: 100)
  end

  def test_transfer_init_parameters_set_properly
    Timecop.freeze do
      transfer = Transfer.new(from: 'Account', to: 'Account', amount: 100, when: Time.now)
      assert_equal 'Account', transfer.from
      assert_equal 'Account', transfer.to
      assert_equal 100, transfer.amount
      assert_equal Time.now, transfer.when
    end
  end

  def test_transfer_deducts_amount
    balance_before = @transfer.from.balance
    @transfer.apply
    assert_equal balance_before - @transfer.amount, @transfer.from.balance
  end

  def test_transfer_increases_amount
    balance_before = @transfer.to.balance
    @transfer.apply
    assert_equal balance_before + @transfer.amount, @transfer.to.balance
  end
end
