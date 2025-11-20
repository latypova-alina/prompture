require "rails_helper"

describe Generator::Video::SuccessNotifierJob do
  let(:job) { described_class.new }

  let(:video_url) { "https://example.com/video.mp4" }
  let(:chat_id) { 456 }
  let(:reply_data) { { text: "hi", parse_mode: "HTML" } }

  before do
    allow(ChatState).to receive(:set)
    allow(Telegram).to receive(:bot).and_return(double(send_message: true, reset: true))

    presenter_double = instance_double(ButtonMessagePresenter, reply_data: reply_data)
    allow(ButtonMessagePresenter).to receive(:new)
      .with(video_url, "video_message")
      .and_return(presenter_double)
  end

  subject { job.perform(video_url, chat_id) }

  describe "#perform" do
    it "sends a Telegram message with presenter reply_data" do
      expect(Telegram.bot).to receive(:send_message).with(
        chat_id: chat_id,
        **reply_data
      )

      subject
    end
  end
end
