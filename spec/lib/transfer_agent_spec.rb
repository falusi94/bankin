# frozen_string_literal: true

require_relative '../../lib/transfer_agent'
require_relative '../../models/bank'
require_relative '../../models/account'

RSpec.describe TransferAgent do
  def setup
    bank = Bank.new(name: 'World Bank')
    account1 = Account.new(user: 'Alice', balance: 3000, bank: bank)
    account2 = Account.new(user: 'Bob', balance: 500, bank: bank)
    account3 = Account.new(user: 'Clark', balance: 800, bank: Bank.new)
    @agent = TransferAgent.new(from: account1, to: account2, amount: 100)
    @inter_bank_agent =
      TransferAgent.new(from: account1, to: account3, amount: 2000, transfer_limit: 1000)
  end

  it 'initializes correctly' do
    transfer_agent_params = { from: 'account1', to: 'account2', amount: 500, transfer_limit: 1500 }
    transfer_agent        = described_class.new(transfer_agent_params)

    expect(transfer_agent).to have_attributes(transfer_agent_params)
  end

  describe '#transfer' do
    before { setup }

    it 'transfers the money' do
      expect(@agent.transfer).to be true
    end

    context 'when transfer involves inter-bank transfers' do
      it 'transfers the money' do
        expect { @inter_bank_agent.transfer }
          .to change { @inter_bank_agent.to.balance }.by(@inter_bank_agent.amount)
      end
    end
  end
end
