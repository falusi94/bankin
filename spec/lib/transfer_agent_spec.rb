# frozen_string_literal: true

RSpec.describe TransferAgent do
  it 'initializes correctly' do
    transfer_agent_params =
      { origin: 'account1', destination: 'account2', amount: 500, transfer_limit: 1500 }
    transfer_agent        = described_class.new(transfer_agent_params)

    expect(transfer_agent).to have_attributes(transfer_agent_params)
  end

  describe '#make_transfer' do
    subject(:make_transfer) { agent.make_transfer }

    let(:origin_account) { build(:account) }
    let(:agent) do
      described_class.new(
        origin:         origin_account,
        destination:    destination_account,
        amount:         2000,
        transfer_limit: 1000
      )
    end

    context 'when the transfer is intra-bank' do
      let(:destination_account) { build(:account, bank: origin_account.bank) }

      it 'adds the money to the destination account' do
        expect { make_transfer }.to change(destination_account, :balance).by(agent.amount)
      end

      it 'returns the transfers' do
        expect(make_transfer).to match(
          [(be_kind_of(Transfer).and have_attributes(origin: origin_account, destination: destination_account))]
        )
      end
    end

    context 'when transfer involves inter-bank transfers' do
      let(:destination_account) { build(:account) }

      it 'adds the money to the destination account' do
        expect { make_transfer }.to change(destination_account, :balance).by(agent.amount)
      end

      it 'returns the transfers' do
        expect(make_transfer)
          .to all(be_kind_of(Transfer).and(have_attributes(origin: origin_account, destination: destination_account)))
      end
    end
  end
end
