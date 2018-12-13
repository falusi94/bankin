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
    return false if fail?

    from.balance -= decrease_amount
    to.balance += amount
    @date = Time.now
    true
  end

  private

  def fail?
    inter_bank? && srand % 100 < 30
  end

  def inter_bank?
    from.bank != to.bank
  end

  def decrease_amount
    return amount unless inter_bank?

    amount + 5
  end
end
