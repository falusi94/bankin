# frozen_string_literal: true

class TransferAgent
  attr_accessor :origin, :destination, :amount, :transfer_limit

  def initialize(origin:, destination:, amount:, transfer_limit: nil)
    @origin         = origin
    @destination    = destination
    @amount         = amount
    @transfer_limit = transfer_limit
  end

  def transfer
    return create_transfer(amount) unless multi_transfer?

    multi_transfer_amount
  end

  private

  def multi_transfer_amount
    transfered_amount = 0
    until transfered_amount == amount
      a = [amount - transfered_amount, transfer_limit].min
      transfered_amount += a if transfer_amount(a)
    end
  end

  def multi_transfer?
    inter_bank? && amount > transfer_limit
  end

  def create_transfer(amount)
    Transfer.create(origin: origin, destination: destination, amount: amount)
  end

  def inter_bank?
    origin.bank != destination.bank
  end
end
