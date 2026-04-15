require "rails_helper"

describe StoreImage::ErrorNotifierJob do
  subject(:perform_job) { described_class.new.perform(record_type, record_id, error_class_name) }

  let!(:record) { create(:user_image_url_message) }
  let(:record_type) { record.class.name }
  let(:record_id) { record.id }
  let(:error_class_name) { "ImageResolutionError" }

  before do
    allow(Telegram.bot).to receive(:send_message)
  end

  describe "#perform" do
    it "sends error message to telegram chat" do
      perform_job

      expect(Telegram.bot).to have_received(:send_message).with(
        chat_id: record.chat_id,
        text: I18n.t("errors.image_resolution"),
        reply_to_message_id: record.tg_message_id
      )
    end

    context "when translation key is missing for error class" do
      let(:error_class_name) { "SomeCustomError" }

      it "falls back to unknown error translation" do
        perform_job

        expect(Telegram.bot).to have_received(:send_message).with(
          chat_id: record.chat_id,
          text: I18n.t("errors.unknown"),
          reply_to_message_id: record.tg_message_id
        )
      end
    end

    context "when tg_message_id is nil" do
      let!(:record) { create(:user_image_url_message, tg_message_id: nil) }

      it "sends error message without reply_to_message_id" do
        perform_job

        expect(Telegram.bot).to have_received(:send_message).with(
          chat_id: record.chat_id,
          text: I18n.t("errors.image_resolution")
        )
      end
    end
  end
end
