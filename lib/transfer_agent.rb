# frozen_string_literal: true

class TransferAgent
  attr_reader :origin, :destination, :amount, :transfer_limit

  def initialize(origin:, destination:, amount:, transfer_limit: nil)
    @origin         = origin
    @destination    = destination
    @amount         = amount
    @transfer_limit = transfer_limit
    @transfers      = []
  end

  def make_transfer
    if multi_transfer?
      multi_transfer_amount
    else
      create_transfer(amount)
    end

    @transfers
  end

  private

  def multi_transfer_amount
    transfered_amount = 0

    until transfered_amount == amount
      amount_to_transfer = [amount - transfered_amount, transfer_limit].min
      transfer           = create_transfer(amount_to_transfer)

      transfered_amount += amount_to_transfer if transfer.successful?
    end
  end

  def multi_transfer?
    inter_bank? && amount > transfer_limit
  end

  def create_transfer(amount)
    Transfer.create(origin: origin, destination: destination, amount: amount).tap { |transfer| @transfers << transfer }
  end

  def inter_bank?
    origin.bank != destination.bank
  end
end
