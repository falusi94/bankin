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
    from.balance -= amount
    to.balance += amount
  end
end
