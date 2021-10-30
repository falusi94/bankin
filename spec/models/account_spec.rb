# frozen_string_literal: true

require_relative '../../models/account'

RSpec.describe Account do
  it 'initializes correctly' do
    account_params = { user: 'Alice', balance: 2300, bank: 'Bank' }
    account        = described_class.new(account_params)

    expect(account).to have_attributes(account_params)
  end
end
