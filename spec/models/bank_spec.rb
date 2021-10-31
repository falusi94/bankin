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
    context 'when the transfer is already stored' do
      it 'does not add it again' do
        transfer = build(:inter_bank_transfer)
        bank     = transfer.origin.bank
        bank.store_transfer(transfer)

        bank.store_transfer(transfer)

        expect(bank.transfers).to match([transfer])
      end
    end

    context 'when the transfer does not belong to the bank' do
      it 'does nothing' do
        transfer = build(:inter_bank_transfer)
        bank     = build(:bank)

        bank.store_transfer(transfer)

        expect(bank.transfers).to be_empty
      end
    end
  end
end
