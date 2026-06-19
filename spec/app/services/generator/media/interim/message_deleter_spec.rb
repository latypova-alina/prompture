require "rails_helper"

describe Generator::Media::Interim::MessageDeleter do
  subject(:call_deleter) { described_class.call(request:) }

  let(:request) do
    create(:button_video_processing_request, interim_tg_message_id: 12_345)
  end

  before do
    allow(TelegramIntegration::DeleteMessage).to receive(:call)
  end

  context "when interim message id is present" do
    it "deletes interim message and clears stored message id" do
      call_deleter

      expect(TelegramIntegration::DeleteMessage)
        .to have_received(:call)
        .with(chat_id: request.chat_id, message_id: 12_345)
      expect(request.reload.interim_tg_message_id).to be_nil
    end
  end

  context "when interim message id is blank" do
    before { request.update!(interim_tg_message_id: nil) }

    it "does not call telegram delete" do
      call_deleter

      expect(TelegramIntegration::DeleteMessage).not_to have_received(:call)
    end
  end
end
