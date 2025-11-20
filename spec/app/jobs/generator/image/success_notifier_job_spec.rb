require "rails_helper"

describe Generator::Image::SuccessNotifierJob do
  let(:job) { described_class.new }

  let(:image_url) { "https://example.com/image.png" }
  let(:chat_id) { 456 }
  let(:reply_data) { { text: "hi", parse_mode: "HTML" } }

  before do
    allow(ChatState).to receive(:set)
    allow(Telegram).to receive(:bot).and_return(double(send_message: true, reset: true))

    presenter_double = instance_double(ButtonMessagePresenter, reply_data: reply_data)
    allow(ButtonMessagePresenter).to receive(:new)
      .with(image_url, "image_message")
      .and_return(presenter_double)
  end

  subject { job.perform(image_url, chat_id) }

  describe "#perform" do
    it "stores the last image URL in ChatState" do
      subject

      expect(ChatState).to have_received(:set)
        .with(chat_id, :last_image_url, image_url)
    end

    it "sends a Telegram message with presenter reply_data" do
      expect(Telegram.bot).to receive(:send_message).with(
        chat_id: chat_id,
        **reply_data
      )

      subject
    end
  end
end
