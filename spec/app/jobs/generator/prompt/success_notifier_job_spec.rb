require "rails_helper"

describe Generator::Prompt::SuccessNotifierJob do
  let(:job) { described_class.new }

  let(:chat_id) { 789 }
  let(:extended_prompt) { "a very long and beautiful prompt" }
  let(:reply_data) { { text: "Prompt text", parse_mode: "HTML" } }

  before do
    fake_bot = double(send_message: true, reset: true)
    allow(Telegram).to receive(:bot).and_return(fake_bot)

    presenter = instance_double(MessagePresenter, reply_data: reply_data)
    allow(MessagePresenter).to receive(:new)
      .with(extended_prompt, "prompt_message")
      .and_return(presenter)
  end

  subject { job.perform(extended_prompt, chat_id) }

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
