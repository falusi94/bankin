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
    from.bank.store_transfer(self)
    to.bank.store_transfer(self)
    return false if invalid?
    return false if fail?

    transfer
  end

  def to_s
    if date
      "Transfered from #{from.user} to #{to.user} #{amount} euros. #{from.user} balance: #{from.balance}, #{to.user} balance: #{to.balance}, when: #{date}"
    else
      "Failed to transfer from #{from.user} to #{to.user} #{amount} euros. #{from.user} balance: #{from.balance}, #{to.user} balance: #{to.balance}"
    end
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

  def transfer
    from.balance -= decrease_amount
    to.balance += amount
    @date = Time.now
    p to_s unless ENV['RAKE_ENV'] == 'test'
    true
  end
end
