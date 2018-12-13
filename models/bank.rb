# frozen_string_literal: true

class Bank
  attr_accessor :name
  attr_reader :accounts, :transfers

  def initialize(params = {})
    @name = params[:name]
    @accounts = []
    @transfers = []
  end

  def store_account(account)
    @accounts << account
  end

  def store_transfer(transfer)
    return if @transfers.include? transfer
    return unless transfer.from.bank == self || transfer.to.bank == self

    @transfers << transfer
  end

  def log_transfers
    return if ENV['RAKE_ENV'] == 'test'
    p '-----------------'
    p "#{name} transfers"
    p '-----------------'
    transfers.each { |transfer| p transfer.to_s }
  end
end
