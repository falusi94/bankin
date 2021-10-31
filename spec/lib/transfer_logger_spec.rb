# frozen_string_literal: true

RSpec.describe TransferLogger do
  context 'when the transfer is successful' do
    it 'prints successful message' do
      transfer        = build(:intra_bank_transfer, :successful)
      transfer_logger = described_class.new(transfer)
      allow(transfer_logger).to receive(:print_message)

      transfer_logger.info

      expect(transfer_logger).to have_received(:print_message).with(/Transfered from/)
    end
  end

  context 'when the transfer is not successful' do
    it 'prints failure message' do
      transfer        = build(:intra_bank_transfer)
      transfer_logger = described_class.new(transfer)
      allow(transfer_logger).to receive(:print_message)

      transfer_logger.info

      expect(transfer_logger).to have_received(:print_message).with(/Failed to/)
    end
  end
end
