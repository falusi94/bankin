# frozen_string_literal: true

RSpec.describe Account do
  describe '.new' do
    it 'initializes correctly' do
      account_params = { user: 'Alice', balance: 2300, bank: 'Bank' }
      account        = described_class.new(account_params)

      expect(account).to have_attributes(account_params)
    end
  end

  describe '#apply_change' do
    let(:account) { build(:account) }

    context 'when the amount is positive' do
      it 'adds it' do
        expect { account.apply_change(5) }.to change(account, :balance).by(5)
      end
    end

    context 'when the amount is negative' do
      it 'subtracts it' do
        expect { account.apply_change(-5) }.to change(account, :balance).by(-5)
      end
    end

    context 'when the transfer is inter-bank' do
      context 'and it fails' do
        it 'raises TransferError' do
          allow(account).to receive(:fail?).and_return(true)

          expect { account.apply_change(5, inter_bank_transfer: true) }
            .to raise_error(TransferError)
        end
      end

      context 'and it does not fail' do
        it 'raises no error' do
          allow(account).to receive(:fail?).and_return(false)

          expect { account.apply_change(5, inter_bank_transfer: true) }.not_to raise_error
        end
      end
    end
  end
end
