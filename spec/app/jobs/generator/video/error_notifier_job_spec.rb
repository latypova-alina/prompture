require "rails_helper"

describe Generator::Video::ErrorNotifierJob do
  let(:chat_id) { 123 }

  before { allow(Telegram).to receive(:bot).and_return(double(send_message: true, reset: true)) }

  subject { described_class.new.perform(chat_id) }

  describe "#perform" do
    it "sends an error message to the user" do
      expect(Telegram.bot).to receive(:send_message).with(
        chat_id: chat_id,
        text: "Sorry, I couldn't generate the video. Please try again later."
      )

      subject
    end
  end
end
