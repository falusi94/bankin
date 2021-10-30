# frozen_string_literal: true

require_relative '../models/transfer'

class TransferAgent
  attr_accessor :from, :to, :amount, :transfer_limit

  def initialize(from:, to:, amount:, transfer_limit: nil)
    @from           = from
    @to             = to
    @amount         = amount
    @transfer_limit = transfer_limit
  end

  def transfer
    return transfer_amount(amount) unless multi_transfer?

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

  def transfer_amount(amount)
    transfer = Transfer.new(from: from, to: to, amount: amount)
    transfer.apply
  end

  def inter_bank?
    from.bank != to.bank
  end
end
