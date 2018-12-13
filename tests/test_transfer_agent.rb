# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/transfer_agent'

class TestTransferAgent < Test::Unit::TestCase
  def test_transfer_agent_can_be_created
    TransferAgent.new
  end

  def test_bank_init_parameters_set_properly
    transfer_agent =
      TransferAgent.new(from: 'account1', to: 'account2', amount: 500, transfer_limit: 1500)
    assert_equal 'account1', transfer_agent.from
    assert_equal 'account2', transfer_agent.to
    assert_equal 500, transfer_agent.amount
    assert_equal 1500, transfer_agent.transfer_limit
  end
end
