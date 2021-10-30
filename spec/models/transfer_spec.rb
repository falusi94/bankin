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
    let(:bank)           { build(:bank) }
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
      let(:destination_account) { Account.new(user: 'Clark', balance: 800, bank: build(:bank)) }

      it 'applies transfer fee to origin account' do
        allow(transfer).to receive(:fail?).and_return(false)

        expect { transfer.apply }
          .to change(origin_account, :balance).by(-transfer.amount - described_class::INTERBANK_FEE)
      end

      context 'and it fails' do
        it 'does not apply the changes' do
          allow(transfer).to receive(:fail?).and_return(true)

          expect do
            expect(transfer.apply).to be false
          end.not_to change(origin_account, :balance)
        end
      end

      context 'and the amount exceeds the limit' do
        it 'does not apply the changes' do
          allow(transfer).to receive(:fail?).and_return(false)
          transfer.amount = described_class::INTERBANK_AMOUNT_LIMIT + 5

          expect do
            expect(transfer.apply).to be false
          end.not_to change(origin_account, :balance)
        end
      end
    end
  end
end
