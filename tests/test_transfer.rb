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
    account3 = Account.new(user: 'Clark', balance: 800, bank: Bank.new)
    @transfer = Transfer.new(from: account1, to: account2, amount: 100)
    @inter_bank_transfer = Transfer.new(from: account1, to: account3, amount: 100)
  end

  def test_transfer_init_parameters_set_properly
    transfer = Transfer.new(from: 'Account', to: 'Account', amount: 100)
    assert_equal 'Account', transfer.from
    assert_equal 'Account', transfer.to
    assert_equal 100, transfer.amount
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

  def test_transfer_fee_applied_on_inter_bank_transfer
    balance_before = @inter_bank_transfer.from.balance
    until @inter_bank_transfer.apply; end
    assert_equal balance_before - @inter_bank_transfer.amount - 5,
                 @inter_bank_transfer.from.balance
  end

  def test_transfer_date_set_on_success
    Timecop.freeze do
      @transfer.apply
      assert_equal Time.now, @transfer.date
    end
  end

  def test_inter_bank_transfer_can_fail
    failed = false
    10_000.times do
      failed = true unless @inter_bank_transfer.apply
    end
    assert_equal true, failed
  end

  def test_inter_bank_transfer_has_limit
    succeded = false
    @inter_bank_transfer.amount = 1200
    10_000.times do
      succeded = true if @inter_bank_transfer.apply
    end
    assert_equal false, succeded
  end
end
