# frozen_string_literal: true

require_relative '../../models/transfer'
require_relative '../../models/bank'
require_relative '../../models/account'

RSpec.describe Transfer do
  describe '.new' do
    it 'initializes correctly' do
      transfer_params = { from: 'from Account', to: 'to Account', amount: 100 }
      transfer        = described_class.new(transfer_params)

      expect(transfer).to have_attributes(transfer_params)
    end
  end

  describe '#apply' do
    let(:bank)           { Bank.new(name: 'World Bank') }
    let(:origin_account) { Account.new(user: 'Alice', balance: 1000, bank: bank) }
    let(:transfer)       { Transfer.new(from: origin_account, to: destination_account, amount: 100) }

    context 'when it is an intra-bank transfer' do
      let(:destination_account) { Account.new(user: 'Bob', balance: 500, bank: bank) }

      it 'subtracts the amount from origin account' do
        expect { transfer.apply }.to change(origin_account, :balance).by(-transfer.amount)
      end

      it 'adds the amount to destination account' do
        expect { transfer.apply }.to change(destination_account, :balance).by(transfer.amount)
      end

      it 'sets the transfer date' do
        Timecop.freeze do
          transfer.apply

          expect(transfer).to have_attributes(date: Time.now)
        end
      end
    end

    context 'when it is an inter-bank transfer' do
      let(:destination_account) { Account.new(user: 'Clark', balance: 800, bank: Bank.new) }

      it 'applies transfer fee to origin account' do
        expect do
          until transfer.apply; end
        end.to change { origin_account.balance }.by(-transfer.amount - 5)
      end

      it 'can fail' do
        failed = false
        10_000.times do
          failed = true unless transfer.apply
        end

        expect(failed).to be true
      end

      it 'has a limit' do
        succeded = false
        transfer.amount = 1200

        10_000.times do
          succeded = true if transfer.apply
        end

        expect(succeded).to be false
      end
    end
  end
end
