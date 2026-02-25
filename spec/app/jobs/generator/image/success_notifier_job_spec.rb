require "rails_helper"

describe Generator::Image::SuccessNotifierJob do
  let(:job) { described_class.new }

  let(:image_url) { "https://example.com/image.png" }
  let(:chat_id) { 456 }
  let(:reply_data) do
    { chat_id: 456,
      parse_mode: "HTML",
      reply_markup: { inline_keyboard: [] },
      text: "<a href=\"https://example.com/image.png\">Open image</a>" }
  end
  let(:button_request) { create(:button_image_processing_request) }

  before do
    allow(Telegram).to receive(:bot).and_return(double(send_message: { "result" => { "message_id" => 789 } },
                                                       reset: true))
  end

  subject { job.perform(image_url, chat_id, button_request.id, :en) }

  describe "#perform" do
    it "sends a Telegram message with presenter reply_data" do
      expect(Telegram.bot).to receive(:send_message).with(
        chat_id:,
        **reply_data
      )

      subject
    end
  end
end
