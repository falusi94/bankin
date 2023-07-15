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
    raise ArgumentError, 'transfer already added' if transfers.include?(transfer)
    raise ArgumentError, 'transfer does not belong to bank' if accounts.exclude?(transfer.origin) &&
                                                               accounts.exclude?(transfer.destination)

    @transfers << transfer
  end

  alias to_s name
end
