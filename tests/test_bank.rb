# frozen_string_literal: true

require 'test/unit'
require_relative '../models/bank'

class TestBank < Test::Unit::TestCase
  def test_bank_can_be_created
    Bank.new
  end
end
