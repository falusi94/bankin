# frozen_string_literal: true

require 'test/unit'
require_relative '../models/account'

class TestAccount < Test::Unit::TestCase
  def test_account_can_be_created
    Account.new
  end
end
