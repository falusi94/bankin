# frozen_string_literal: true

class Transfer
  attr_accessor :from, :to, :amount
  attr_reader :date

  def initialize(params = {})
    @from = params[:from]
    @to = params[:to]
    @amount = params[:amount]
  end

  def apply
    from.balance -= decrease_amount
    to.balance += amount
    @date = Time.now
  end

  private

  def decrease_amount
    return amount if from.bank == to.bank

    amount + 5
  end
end
