# frozen_string_literal: true

require_relative '../../lib/transfer_agent'
require_relative '../../models/bank'
require_relative '../../models/account'

RSpec.describe TransferAgent do
  it 'initializes correctly' do
    transfer_agent_params = { from: 'account1', to: 'account2', amount: 500, transfer_limit: 1500 }
    transfer_agent        = described_class.new(transfer_agent_params)

    expect(transfer_agent).to have_attributes(transfer_agent_params)
  end

  describe '#transfer' do
    let(:bank)           { Bank.new(name: 'World Bank') }
    let(:origin_account) { Account.new(user: 'Alice', balance: 3000, bank: bank) }

    context 'when the transfer is intra-bank' do
      it 'transfers the money' do
        destination_account = Account.new(user: 'Bob', balance: 500, bank: bank)
        agent = described_class.new(from: origin_account, to: destination_account, amount: 100)

        expect(agent.transfer).to be true
      end
    end

    context 'when transfer involves inter-bank transfers' do
      it 'transfers the money' do
        destination_account = Account.new(user: 'Clark', balance: 500, bank: Bank.new)
        agent = described_class.new(
          from:           origin_account,
          to:             destination_account,
          amount:         2000,
          transfer_limit: 1000
        )

        expect { agent.transfer }.to change(destination_account, :balance).by(agent.amount)
      end
    end
  end
end
