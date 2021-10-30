# frozen_string_literal: true

require_relative '../../lib/transfer_agent'
require_relative '../../models/bank'
require_relative '../../models/account'

RSpec.describe TransferAgent do
  it 'initializes correctly' do
    transfer_agent_params =
      { origin: 'account1', destination: 'account2', amount: 500, transfer_limit: 1500 }
    transfer_agent        = described_class.new(transfer_agent_params)

    expect(transfer_agent).to have_attributes(transfer_agent_params)
  end

  describe '#transfer' do
    let(:origin_account) { build(:account) }

    context 'when the transfer is intra-bank' do
      it 'transfers the money' do
        destination_account = build(:account, bank: origin_account.bank)
        agent = described_class.new(origin: origin_account, destination: destination_account, amount: 100)

        expect(agent.transfer).to be true
      end
    end

    context 'when transfer involves inter-bank transfers' do
      it 'transfers the money' do
        destination_account = build(:account)
        agent = described_class.new(
          origin:         origin_account,
          destination:    destination_account,
          amount:         2000,
          transfer_limit: 1000
        )

        expect { agent.transfer }.to change(destination_account, :balance).by(agent.amount)
      end
    end
  end
end
