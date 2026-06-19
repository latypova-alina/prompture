module TelegramIntegration
  module CallbackQuery
    class OtherButtonHandler
      include Memery

      SET_LOCALE_COMMAND = "set_locale".freeze

      HANDLERS = {
        SET_LOCALE_COMMAND => :handle_set_locale,
        ButtonActions::PROVIDE_PROMPT => :handle_provide_prompt_button,
        ButtonActions::GENERATE_CARTOON_VIDEO => :handle_generate_cartoon_video_button,
        ButtonActions::GENERATE_CARTOON_AUDIO => :handle_generate_cartoon_audio_button,
        ButtonActions::MERGE_CARTOON_AUDIO_VIDEO => :handle_merge_cartoon_audio_video_button,
        ButtonActions::REGENERATE_SINGLE_CARTOON_SCRIPT_IMAGE => :handle_regenerate_single_cartoon_script_image_button,
        ButtonActions::CHECK_GENERATION_STATUS => :handle_check_generation_status,
        ButtonActions::CANCEL_GENERATION => :handle_cancel_generation
      }.freeze
      DEFAULT_HANDLER = :handle_media_button

      def self.call(...)
        new(...).call
      end

      def initialize(button_request:, chat_id:, tg_message_id:, callback_query_id:)
        @button_request = button_request
        @chat_id = chat_id
        @tg_message_id = tg_message_id
        @callback_query_id = callback_query_id
      end

      def call
        send(HANDLERS.fetch(button_action, DEFAULT_HANDLER))
      end

      private

      attr_reader :button_request, :chat_id, :tg_message_id, :callback_query_id

      def button_action
        splitted_button_request.first
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

      def handle_check_generation_status
        MediaGenerator::ButtonHandler::CheckGenerationStatus.call(
          button_request:,
          callback_query_id:
        )
      end

      def handle_cancel_generation
        MediaGenerator::ButtonHandler::CancelGeneration.call(
          button_request:,
          callback_query_id:
        )
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
