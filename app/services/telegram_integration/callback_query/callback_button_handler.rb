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
        when ButtonActions::PROVIDE_PROMPT
          handle_provide_prompt_button
        when ButtonActions::GENERATE_CARTOON_VIDEO
          handle_generate_cartoon_video_button
        when ButtonActions::GENERATE_CARTOON_AUDIO
          handle_generate_cartoon_audio_button
        when ButtonActions::MERGE_CARTOON_AUDIO_VIDEO
          handle_merge_cartoon_audio_video_button
        when ButtonActions::REGENERATE_SINGLE_CARTOON_SCRIPT_IMAGE
          handle_regenerate_single_cartoon_script_image_button
        else
          handle_media_button
        end
      end

      def handle_provide_prompt_button
        MediaGenerator::ButtonHandler::HandleProvidePromptButton.call(**media_button_handler_params)
      end

      def handle_generate_cartoon_video_button
        MediaGenerator::ButtonHandler::HandleGenerateCartoonVideoButton.call(**media_button_handler_params)
      end

      def handle_generate_cartoon_audio_button
        MediaGenerator::ButtonHandler::HandleGenerateCartoonAudioButton.call(**media_button_handler_params)
      end

      def handle_merge_cartoon_audio_video_button
        MediaGenerator::ButtonHandler::HandleMergeCartoonAudioVideoButton.call(**media_button_handler_params)
      end

      def handle_regenerate_single_cartoon_script_image_button
        MediaGenerator::ButtonHandler::HandleRegenerateSingleCartoonScriptImageButton.call(**media_button_handler_params)
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
