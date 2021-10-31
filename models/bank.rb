# frozen_string_literal: true

class Bank
  attr_reader :accounts, :transfers, :name

  def initialize(name: '')
    @name      = name
    @accounts  = []
    @transfers = []
  end

  def store_account(account)
    @accounts << account
  end

  def store_transfer(transfer)
    return if transfers.include?(transfer) ||
              accounts.exclude?(transfer.origin) && accounts.exclude?(transfer.destination)

    @transfers << transfer
  end

  def log_transfers
    p '-----------------'
    p "#{name} transfers"
    p '-----------------'
    transfers.each { |transfer| TransferLogger.info(transfer) }
  end
end
