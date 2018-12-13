# frozen_string_literal: true

require_relative '../models/transfer'

class TransferAgent
  attr_accessor :from, :to, :amount, :transfer_limit

  def initialize(params = {})
    @from = params[:from]
    @to = params[:to]
    @amount = params[:amount]
    @transfer_limit = params[:transfer_limit]
  end

  def transfer
    transfer = Transfer.new(from: from, to: to, amount: amount)
    transfer.apply
  end
end
