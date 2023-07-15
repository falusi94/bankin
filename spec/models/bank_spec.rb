# frozen_string_literal: true

RSpec.describe Bank do
  describe '.new' do
    it 'initializes correctly' do
      bank_params = { name: 'Bank' }
      bank        = described_class.new(bank_params)

      expect(bank).to have_attributes(bank_params)
    end
  end

  describe '#store_transfer' do
    let(:bank) { build(:bank) }

    context 'when the transfer is already stored' do
      it 'raises ArgumentError' do
        account  = build(:account, bank: bank)
        transfer = build(:transfer, origin: account)
        bank.store_transfer(transfer)

        expect { bank.store_transfer(transfer) }.to raise_error(ArgumentError, 'transfer already added')

        expect(bank.transfers).to match([transfer])
      end
    end

    context 'when the transfer is already stored' do
      it 'does nothing' do
        transfer = build(:transfer)

        expect { bank.store_transfer(transfer) }.to raise_error(ArgumentError, 'transfer does not belong to bank')

        expect(bank.transfers).to be_empty
      end
    end
  end
end
