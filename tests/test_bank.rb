# frozen_string_literal: true

require 'test/unit'
require_relative '../models/bank'

class TestBank < Test::Unit::TestCase
  def test_bank_can_be_created
    Bank.new
  end

  def test_bank_init_parameters_set_properly
    bank = Bank.new(name: 'World Bank')
    assert_equal 'World Bank', bank.name
  end
end
