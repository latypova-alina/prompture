module Buttons
  module ForPromptMessage
    class ForAudio < Buttons::Base
      GET_AUDIO_SAMPLES = Audio::SendVoiceSamples::GET_AUDIO_SAMPLES_CALLBACK

      def build
        processor_rows + [[samples_button]]
      end

      private

      def processor_rows
        Audio::VoiceCatalog.slugs.map { |slug| [audio_voice_button_for(slug)] }
      end

      def samples_button
        {
          text: I18n.t("telegram_webhooks.message.buttons.get_audio_samples", locale:),
          callback_data: GET_AUDIO_SAMPLES
        }
      end

      def audio_voice_button_for(voice_slug)
        {
          text: I18n.t(
            "telegram_webhooks.message.buttons.generate_audio.#{voice_slug}",
            count: audio_generation_cost,
            locale:
          ),
          callback_data: voice_slug.to_s
        }
      end

      def audio_generation_cost
        COSTS[:generate_audio][Audio::VoiceCatalog::DEFAULT_PROCESSOR]
      end
    end
  end
end
