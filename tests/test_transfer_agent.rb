# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/transfer_agent'

class TestTransferAgent < Test::Unit::TestCase
  def test_transfer_agent_can_be_created
    TransferAgent.new
  end
end
