require "rails_helper"

describe Generator::Media::Image::ErrorNotifierJob do
  subject(:perform_job) { described_class.new.perform(button_request.id) }

  let(:button_request) { create(:button_image_processing_request, status: "PENDING") }

  let(:telegram_bot) { double }

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive(:send_message)
  end

  describe "#perform" do
    it "sends telegram message with correct chat_id and error text" do
      expect(telegram_bot).to receive(:send_message).with(
        chat_id: button_request.chat_id,
        text: I18n.t("errors.image_generating_error")
      )

      perform_job
    end

    it "updates request status to FAILED" do
      expect { perform_job }
        .to change { button_request.reload.status }
        .from("PENDING")
        .to("FAILED")
    end
  end
end
