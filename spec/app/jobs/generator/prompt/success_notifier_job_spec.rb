require "rails_helper"

describe Generator::Prompt::SuccessNotifierJob do
  let(:job) { described_class.new }

  let(:chat_id) { 789 }
  let(:extended_prompt) { "a very long and beautiful prompt" }
  let(:reply_data) do
    { chat_id: 789,
      parse_mode: "HTML",
      reply_markup:
   { inline_keyboard:
     [
       [{ callback_data: "mystic_image", text: "Mystic (2 credits)" }],
       [{ callback_data: "gemini_image", text: "Gemini (1 credit)" }],
       [{ callback_data: "imagen_image", text: "Imagen (0 credits)" }]
     ] },
      text: "a very long and beautiful prompt" }
  end
  let(:command_request) { create(:command_prompt_to_image_request) }
  let(:button_request) do
    create(:button_extend_prompt_request, parent_request: command_request, command_request:)
  end

  before do
    allow(Telegram).to receive(:bot).and_return(double(send_message: { "result" => { "message_id" => 789 } },
                                                       reset: true))
  end

  subject { job.perform(extended_prompt, chat_id, button_request.id, "en") }

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
