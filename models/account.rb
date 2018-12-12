# frozen_string_literal: true

class Account
  attr_accessor :user, :balance, :bank

  def initialize(params = {})
    @user = params[:user]
    @balance = params[:balance]
    @bank = params[:bank]
  end
end
