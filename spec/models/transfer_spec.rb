# frozen_string_literal: true

require_relative '../../models/transfer'
require_relative '../../models/bank'
require_relative '../../models/account'

RSpec.describe Transfer do
  def setup
    bank = Bank.new(name: 'World Bank')
    account1 = Account.new(user: 'Alice', balance: 1000, bank: bank)
    account2 = Account.new(user: 'Bob', balance: 500, bank: bank)
    account3 = Account.new(user: 'Clark', balance: 800, bank: Bank.new)
    @transfer = Transfer.new(from: account1, to: account2, amount: 100)
    @inter_bank_transfer = Transfer.new(from: account1, to: account3, amount: 100)
  end

  describe '.new' do
    it 'initializes correctly' do
      transfer_params = { from: 'from Account', to: 'to Account', amount: 100 }
      transfer        = described_class.new(transfer_params)

      expect(transfer).to have_attributes(transfer_params)
    end
  end

  describe '#apply' do
    before { setup }

    it 'subtracts the amount from origin account' do
      expect { @transfer.apply }.to change { @transfer.from.balance }.by(-@transfer.amount)
    end

    it 'adds the amount to destination account' do
      expect { @transfer.apply }.to change { @transfer.to.balance }.by(@transfer.amount)
    end

    it 'sets the transfer date' do
      Timecop.freeze do
        @transfer.apply

        expect(@transfer).to have_attributes(date: Time.now)
      end
    end

    context 'when it is an inter-bank transfer' do
      it 'applies transfer fee to origin account' do
        expect do
          until @inter_bank_transfer.apply; end
        end.to change { @inter_bank_transfer.from.balance }.by(-@inter_bank_transfer.amount - 5)
      end

      it 'can fail' do
        failed = false
        10_000.times do
          failed = true unless @inter_bank_transfer.apply
        end

        expect(failed).to be true
      end

      it 'has a limit' do
        succeded = false
        @inter_bank_transfer.amount = 1200

        10_000.times do
          succeded = true if @inter_bank_transfer.apply
        end

        expect(succeded).to be false
      end
    end
  end
end
