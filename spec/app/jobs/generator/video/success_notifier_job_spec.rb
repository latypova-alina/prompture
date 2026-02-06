require "rails_helper"

describe Generator::Video::SuccessNotifierJob do
  let(:job) { described_class.new }

  let(:video_url) { "https://example.com/video.mp4" }
  let(:chat_id) { 456 }
  let(:reply_data) do
    { chat_id: 456,
      parse_mode: "HTML",
      reply_markup: { inline_keyboard: [] },
      text: "<a href=\"https://example.com/video.mp4\">Open video</a>" }
  end
  let(:command_request) { create(:command_prompt_to_video_request) }
  let(:button_request) do
    create(:button_video_processing_request, parent_request: command_request, command_request:)
  end

  before do
    allow(Telegram).to receive(:bot).and_return(double(send_message: { "result" => { "message_id" => 789 } },
                                                       reset: true))
  end

  subject { job.perform(video_url, chat_id, button_request.id) }

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
