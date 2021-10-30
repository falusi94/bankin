# frozen_string_literal: true

require_relative '../../models/bank'

RSpec.describe Bank do
  it 'initializes correctly' do
    bank_params = { name: 'Bank' }
    bank        = described_class.new(bank_params)

    expect(bank).to have_attributes(bank_params)
  end
end