# frozen_string_literal: true

RSpec.describe Transfer do
  describe '.new' do
    it 'initializes correctly' do
      transfer_params = { origin: 'from Account', destination: 'to Account', amount: 100 }
      transfer        = described_class.new(transfer_params)

      expect(transfer).to have_attributes(transfer_params)
    end
  end

  describe '.create' do
    it 'initializes and applies the transfer' do
      attributes = attributes_for(:intra_bank_transfer)

      transfer = described_class.create(attributes)

      expect(transfer).to be_successful.and have_attributes(attributes)
    end
  end

  describe '#apply' do
    let(:origin_account) { transfer.origin }
    let(:destination_account) { transfer.destination }

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

          expect(transfer).to have_attributes(completed_at: Time.now)
        end
      end
    end

    context 'when it is an inter-bank transfer' do
      let(:transfer) { build(:inter_bank_transfer) }

      it 'applies transfer fee to origin account' do
        allow(destination_account).to receive(:fail?).and_return(false)

        expect { transfer.apply }
          .to change(origin_account, :balance).by(-transfer.amount - described_class::INTERBANK_FEE)
      end

      context 'and it fails' do
        it 'does not apply the changes' do
          allow(destination_account).to receive(:fail?).and_return(true)

          expect do
            expect(transfer.apply).to be false
          end.not_to change(origin_account, :balance)
        end
      end

      context 'and the amount exceeds the limit' do
        let(:transfer) { build(:inter_bank_transfer, :over_limit) }

        it 'does not apply the changes' do
          allow(destination_account).to receive(:fail?).and_return(false)

          expect do
            expect(transfer.apply).to be false
          end.not_to change(origin_account, :balance)
        end
      end
    end
  end

  describe '#successful?' do
    subject(:successful?) { transfer.successful? }

    context 'when the transfer is successful' do
      let(:transfer) { build(:transfer, :successful) }

      it { is_expected.to be(true) }
    end

    context 'when the transfer is not successful' do
      let(:transfer) { build(:transfer) }

      it { is_expected.to be(false) }
    end
  end
end
