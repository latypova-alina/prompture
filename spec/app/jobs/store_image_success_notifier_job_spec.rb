require "rails_helper"

describe StoreImage::SuccessNotifierJob do
  subject(:perform_job) { described_class.new.perform(record_type, record_id) }

  let!(:record) { create(:user_image_url_message, tg_message_id: tg_message_id) }
  let(:record_type) { record.class.name }
  let(:record_id) { record.id }
  let(:tg_message_id) { 123_456 }
  let(:presenter_selector) { instance_double(MediaGenerator::UserMessage::ImageMessage::PresenterSelector) }
  let(:presenter) { instance_double(MediaGenerator::UserMessage::ImageMessage::ImageUrlMessagePresenter) }
  let(:reply_data) { { text: "Great! You can now generate a video using one of the processors (Kling)" } }

  before do
    allow(MediaGenerator::UserMessage::ImageMessage::PresenterSelector)
      .to receive(:new).with(request: record).and_return(presenter_selector)
    allow(presenter_selector).to receive(:presenter).and_return(presenter)
    allow(presenter).to receive(:reply_data).and_return(reply_data)
    allow(TelegramIntegration::SendMessageWithButtons).to receive(:call)
  end

  describe "#perform" do
    it "sends success message with reply_to_message_id" do
      perform_job

      expect(TelegramIntegration::SendMessageWithButtons).to have_received(:call).with(
        reply_data: reply_data.merge(reply_to_message_id: tg_message_id),
        request: record
      )
    end

    context "when tg_message_id is nil" do
      let!(:record) { create(:user_image_url_message, tg_message_id: nil) }
      let(:tg_message_id) { nil }

      it "sends success message without reply_to_message_id" do
        perform_job

        expect(TelegramIntegration::SendMessageWithButtons).to have_received(:call).with(
          reply_data:,
          request: record
        )
      end
    end
  end
end
