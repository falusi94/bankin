# frozen_string_literal: true

require 'test/unit'
require_relative '../models/transfer'

class TestTransfer < Test::Unit::TestCase
  def test_transfer_can_be_created
    Transfer.new
  end
end
