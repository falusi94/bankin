# frozen_string_literal: true

class Bank
  attr_accessor :name
  attr_reader :accounts, :transfers

  def initialize(name: '')
    @name      = name
    @accounts  = []
    @transfers = []
  end

  def store_account(account)
    @accounts << account
  end

  def store_transfer(transfer)
    return if @transfers.include? transfer
    return unless transfer.origin.bank == self || transfer.destination.bank == self

    @transfers << transfer
  end

  def log_transfers
    p '-----------------'
    p "#{name} transfers"
    p '-----------------'
    transfers.each { |transfer| TransferLogger.info(transfer) }
  end
end
