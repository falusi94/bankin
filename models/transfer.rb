# frozen_string_literal: true

class Transfer
  INTERBANK_FEE          = 5
  INTERBANK_AMOUNT_LIMIT = 1000

  attr_reader :origin, :destination, :amount, :date

  def initialize(origin: nil, destination: nil, amount: nil)
    @origin      = origin
    @destination = destination
    @amount      = amount
  end

  def apply
    origin.bank.store_transfer(self)
    destination.bank.store_transfer(self)
    return false if invalid?

    do_transfer
  end

  private

  def invalid?
    inter_bank? && amount > INTERBANK_AMOUNT_LIMIT
  end

  def inter_bank?
    origin.bank != destination.bank
  end

  def decrease_amount
    return amount unless inter_bank?

    amount + INTERBANK_FEE
  end

  def do_transfer
    origin.apply_change(-decrease_amount)
    destination.apply_change(amount, inter_bank_transfer: inter_bank?)

    @date = Time.now
    TransferLogger.info(self)
    true
  rescue TransferError
    origin.apply_change(decrease_amount)
    false
  end
end
