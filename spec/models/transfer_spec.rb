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
    let(:origin_account) { transfer.from }
    let(:destination_account) { transfer.to }

    context 'when it is an intra-bank transfer' do
      let(:transfer) { build(:intra_bank_transfer) }

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
      let(:transfer) { build(:inter_bank_transfer) }

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
        let(:transfer) { build(:inter_bank_transfer, :over_limit) }

        it 'does not apply the changes' do
          allow(transfer).to receive(:fail?).and_return(false)

          expect do
            expect(transfer.apply).to be false
          end.not_to change(origin_account, :balance)
        end
      end
    end
  end
end
