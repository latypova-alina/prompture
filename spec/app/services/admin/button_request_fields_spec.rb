require "rails_helper"

describe Admin::ButtonRequestFields do
  subject { described_class.call(button_request) }

  let(:button_request) { create(:button_image_processing_request, :completed) }

  it { is_expected.to include("processor" => "flux_image", "cost" => button_request.cost, "status" => "COMPLETED") }
  it { is_expected.not_to include("audio_prompt", "bot_message_chat_id") }

  context "when the bot sent a Telegram message for it" do
    before { create(:bot_telegram_message, request: button_request, chat_id: 42, tg_message_id: 99) }

    it { is_expected.to include("bot_message_chat_id" => 42, "bot_message_tg_message_id" => 99) }
  end

  context "when it is an audio request with an audio prompt" do
    let(:audio_prompt) { create(:audio_prompt, prompt: "Hello there") }
    let(:button_request) { create(:button_audio_processing_request, audio_prompt:) }

    it { is_expected.to include("audio_prompt" => "Hello there", "voice" => "adam") }
  end
end
