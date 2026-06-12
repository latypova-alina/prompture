require "rails_helper"

describe MediaGenerator::ButtonHandler::AcknowledgeCallbackQuery do
  subject(:result) do
    described_class.call(
      callback_query_id:,
      button_request:,
      command_request:
    )
  end

  let(:callback_query_id) { "callback-123" }
  let(:user) { create(:user, locale: "en") }
  let(:command_request) { create(:command_edit_image_request, user:) }

  before do
    allow(TelegramIntegration::SendAnswerCallbackQuery).to receive(:call)
  end

  context "when generating cartoon video" do
    let(:button_request) { ButtonActions::GENERATE_CARTOON_VIDEO }

    it "shows the processing toast immediately" do
      result

      expect(TelegramIntegration::SendAnswerCallbackQuery)
        .to have_received(:call)
        .with(
          callback_query_id:,
          process_name: I18n.t(
            "telegram.generation.humanized_process_names.video.veo3_1_lite_image_to_video",
            locale: "en"
          )
        )
    end
  end

  context "when generating cartoon audio" do
    let(:button_request) { ButtonActions::GENERATE_CARTOON_AUDIO }
    let(:command_request) { create(:command_prompt_to_video_request, user:) }

    it "shows the processing toast immediately" do
      result

      expect(TelegramIntegration::SendAnswerCallbackQuery)
        .to have_received(:call)
        .with(
          callback_query_id:,
          process_name: I18n.t(
            "telegram.generation.humanized_process_names.audio.voices.lulu_lollipop",
            locale: "en"
          )
        )
    end
  end

  context "when callback_query_id is blank" do
    let(:button_request) { ButtonActions::GENERATE_CARTOON_VIDEO }
    let(:callback_query_id) { nil }

    it "does not call Telegram" do
      result

      expect(TelegramIntegration::SendAnswerCallbackQuery).not_to have_received(:call)
    end
  end
end
