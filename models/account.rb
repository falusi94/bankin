# frozen_string_literal: true

class Account
  INTERBANK_FAILURE_RATE = 30

  attr_reader :user, :bank, :balance

  def initialize(user: nil, balance: nil, bank: nil)
    @user    = user
    @balance = balance
    @bank    = bank
  end

  def apply_change(amount, inter_bank_transfer: false)
    raise TransferError if inter_bank_transfer && fail?

    @balance += amount
  end

  private

  def fail?
    srand % 100 < INTERBANK_FAILURE_RATE
  end
end
