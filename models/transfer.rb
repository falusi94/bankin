# frozen_string_literal: true

class Transfer
  INTERBANK_FEE          = 5
  INTERBANK_AMOUNT_LIMIT = 1000
  INTERBANK_FAILURE_RATE = 30

  attr_accessor :origin, :destination, :amount
  attr_reader :date

  def initialize(origin: nil, destination: nil, amount: nil)
    @origin      = origin
    @destination = destination
    @amount      = amount
  end

  def apply
    origin.bank.store_transfer(self)
    destination.bank.store_transfer(self)
    return false if invalid?
    return false if fail?

    transfer
  end

  private

  def invalid?
    inter_bank? && amount > INTERBANK_AMOUNT_LIMIT
  end

  def fail?
    inter_bank? && srand % 100 < INTERBANK_FAILURE_RATE
  end

  def inter_bank?
    origin.bank != destination.bank
  end

  def decrease_amount
    return amount unless inter_bank?

    amount + INTERBANK_FEE
  end

  def transfer
    origin.balance -= decrease_amount
    destination.balance += amount
    @date = Time.now
    TransferLogger.info(self) unless ENV['RAKE_ENV'] == 'test'
    true
  end
end
