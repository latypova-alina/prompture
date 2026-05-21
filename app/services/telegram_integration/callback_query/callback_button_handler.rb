module TelegramIntegration
  module CallbackQuery
    class CallbackButtonHandler
      include Memery

      SET_LOCALE_COMMAND = "set_locale".freeze
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
          handle_other_button
        end
      end

      private

      attr_reader :button_request, :chat_id, :tg_message_id, :callback_query_id

      def handle_other_button
        case splitted_button_request.first
        when SET_LOCALE_COMMAND
          handle_set_locale
        else
          handle_media_button
        end
      end

      def handle_get_audio_samples
        Audio::SendVoiceSamples.call(chat_id:)
      end

      memoize def splitted_button_request
        button_request.split(":")
      end

      def handle_set_locale
        SetLocale::ButtonHandler::HandleButton.call(selected_locale: splitted_button_request.last, chat_id:)
      end

      def handle_media_button
        MediaGenerator::ButtonHandler::HandleButton.call(**media_button_handler_params)
      end

      def media_button_handler_params
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
