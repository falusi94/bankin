# frozen_string_literal: true

class TransferAgent
  attr_accessor :from, :to, :amount, :transfer_limit

  def initialize(params = {})
    @from = params[:from]
    @to = params[:to]
    @amount = params[:amount]
    @transfer_limit = params[:transfer_limit]
  end
end
