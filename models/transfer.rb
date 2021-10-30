# frozen_string_literal: true

class Transfer
  INTERBANK_FEE          = 5
  INTERBANK_AMOUNT_LIMIT = 1000
  INTERBANK_FAILURE_RATE = 30

  attr_accessor :from, :to, :amount
  attr_reader :date

  def initialize(from: nil, to: nil, amount: nil)
    @from   = from
    @to     = to
    @amount = amount
  end

  def apply
    from.bank.store_transfer(self)
    to.bank.store_transfer(self)
    return false if invalid?
    return false if fail?

    transfer
  end

  def to_s
    if date
      "Transfered from #{from.user} to #{to.user} #{amount} euros. #{from.user} balance: #{from.balance}, #{to.user} balance: #{to.balance}, when: #{date}"
    else
      "Failed to transfer from #{from.user} to #{to.user} #{amount} euros. #{from.user} balance: #{from.balance}, #{to.user} balance: #{to.balance}"
    end
  end

  private

  def invalid?
    inter_bank? && amount > INTERBANK_AMOUNT_LIMIT
  end

  def fail?
    inter_bank? && srand % 100 < INTERBANK_FAILURE_RATE
  end

  def inter_bank?
    from.bank != to.bank
  end

  def decrease_amount
    return amount unless inter_bank?

    amount + INTERBANK_FEE
  end

  def transfer
    from.balance -= decrease_amount
    to.balance += amount
    @date = Time.now
    p to_s unless ENV['RAKE_ENV'] == 'test'
    true
  end
end
