# frozen_string_literal: true

require 'test/unit'
require 'timecop'
require_relative '../models/transfer'

class TestTransfer < Test::Unit::TestCase
  def test_transfer_can_be_created
    Transfer.new
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
end
