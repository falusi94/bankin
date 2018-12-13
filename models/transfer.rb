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
    return false if invalid?
    return false if fail?

    from.balance -= decrease_amount
    to.balance += amount
    @date = Time.now
    log
    true
  end

  private

  def invalid?
    inter_bank? && amount > 1000
  end

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

  def log
    p "Transfered from #{from.user} to #{to.user} #{amount} euros. #{from.user} balance #{from.balance}, #{to.user} #{to.balance}"
  end
end
