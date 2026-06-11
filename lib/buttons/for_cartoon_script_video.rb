module Buttons
  class ForCartoonScriptVideo < ForVideoMessage
    def build
      [[regenerate_button], [generate_audio_button]]
    end

    private

    def generate_audio_button
      {
        text: I18n.t(
          "telegram_webhooks.message.buttons.generate_cartoon_audio",
          count: audio_cost,
          locale:
        ),
        callback_data: ButtonActions::GENERATE_CARTOON_AUDIO
      }
    end

    def audio_cost
      COSTS[:generate_audio][:elevenlabs_v3_audio]
    end
  end
end
