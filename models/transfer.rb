# frozen_string_literal: true

class Transfer
  INTERBANK_FEE          = 5
  INTERBANK_AMOUNT_LIMIT = 1000

  attr_reader :origin, :destination, :amount, :completed_at

  def initialize(origin: nil, destination: nil, amount: nil)
    @origin      = origin
    @destination = destination
    @amount      = amount
  end

  def apply
    store_transfer_in_banks
    return false if inter_bank? && over_limit?

    transfer_money
    mark_successful
    true
  rescue TransferError
    rollback_transfer
    false
  end

  def self.create(*args)
    new(*args).tap(&:apply)
  end

  def successful?
    completed_at.present?
  end

  private

  def store_transfer_in_banks
    origin.bank.store_transfer(self)
    destination.bank.store_transfer(self) if inter_bank?
  end

  def over_limit?
    amount > INTERBANK_AMOUNT_LIMIT
  end

  def inter_bank?
    origin.bank != destination.bank
  end

  def transfer_money
    origin.apply_change(-amount_to_subtract)
    destination.apply_change(amount, inter_bank_transfer: inter_bank?)
  end

  def mark_successful
    @completed_at = Time.now
  end

  def rollback_transfer
    origin.apply_change(amount_to_subtract)
  end

  def amount_to_subtract
    inter_bank? ? amount + INTERBANK_FEE : amount
  end
end
