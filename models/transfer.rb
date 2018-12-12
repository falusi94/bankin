# frozen_string_literal: true

class Transfer
  attr_accessor :from, :to, :amount, :when

  def initialize(params = {})
    @from = params[:from]
    @to = params[:to]
    @amount = params[:amount]
    @when = params[:when]
  end

  def apply
    from.balance -= decrease_amount
    to.balance += amount
  end

  private

  def decrease_amount
    return amount if from.bank == to.bank

    amount + 5
  end
end
