# frozen_string_literal: true

require 'test/unit'
require_relative '../models/account'

class TestAccount < Test::Unit::TestCase
  def test_account_can_be_created
    Account.new
  end

  def test_account_init_parameters_set_properly
    account = Account.new(user: 'Alice', balance: 2300, bank: 'Bank')
    assert_equal 'Alice', account.user
    assert_equal 2300, account.balance
    assert_equal 'Bank', account.bank
  end
end
