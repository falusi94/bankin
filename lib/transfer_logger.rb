# frozen_string_literal: true

class TransferLogger
  def initialize(transfer)
    @transfer = transfer
  end

  def self.info(transfer)
    new(transfer).info
  end

  def info
    message = build_message

    print_message(message)
  end

  private

  def build_message
    if completed_at
      successful_message
    else
      failure_message
    end
  end

  def print_message(message)
    puts message
  end

  def successful_message
    "Transfered from #{origin.user} to #{destination.user} #{amount} euros. #{origin.user}" \
      " balance: #{origin.balance}, #{destination.user} balance: #{destination.balance}," \
      " when: #{completed_at}"
  end

  def failure_message
    "Failed to transfer from #{origin.user} to #{destination.user} #{amount} euros." \
      " #{origin.user} balance: #{origin.balance}, #{destination.user} balance:" \
      " #{destination.balance}"
  end

  delegate :origin, :destination, :amount, :completed_at, to: :transfer

  attr_reader :transfer
end
