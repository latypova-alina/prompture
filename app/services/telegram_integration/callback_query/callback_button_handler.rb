module TelegramIntegration
  module CallbackQuery
    class CallbackButtonHandler
      GET_AUDIO_SAMPLES_CALLBACK = Audio::SendVoiceSamples::GET_AUDIO_SAMPLES_CALLBACK

      def initialize(button_request:, chat_id:, tg_message_id:, callback_query_id:)
        @button_request = button_request
        @chat_id = chat_id
        @tg_message_id = tg_message_id
        @callback_query_id = callback_query_id
      end

      def handled_button
        case button_request
        when GET_AUDIO_SAMPLES_CALLBACK
          handle_get_audio_samples
        else
          OtherButtonHandler.call(**handler_params)
        end
      end

      private

      attr_reader :button_request, :chat_id, :tg_message_id, :callback_query_id

      def handle_get_audio_samples
        Audio::SendVoiceSamples.call(chat_id:)
      end

      def handler_params
        {
          button_request:,
          chat_id:,
          tg_message_id:,
          callback_query_id:
        }
      end
    end
  end
end
