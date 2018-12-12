# frozen_string_literal: true

class Bank
  attr_accessor :name

  def initialize(params = {})
    @name = params[:name]
  end
end
