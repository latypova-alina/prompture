module MediaGenerator
  module ButtonHandler
    class AcknowledgeCallbackQuery
      include Interactor

      delegate :callback_query_id, :button_request, :command_request, to: :context
      delegate :user, to: :command_request
      delegate :locale, to: :user

      def call
        return if callback_query_id.blank?

        TelegramIntegration::SendAnswerCallbackQuery.call(
          callback_query_id:,
          process_name: processing_toast_name
        )
      end

      private

      def processing_toast_name
        case button_request
        when ButtonActions::GENERATE_CARTOON_VIDEO
          cartoon_video_process_name
        when ButtonActions::GENERATE_CARTOON_AUDIO
          cartoon_audio_process_name
        when ButtonActions::MERGE_CARTOON_AUDIO_VIDEO
          cartoon_merge_process_name
        end
      end

      def cartoon_video_process_name
        I18n.t(
          "telegram.generation.humanized_process_names.video.#{CreateCartoonVideoRequest::PROCESSOR}",
          locale:
        )
      end

      def cartoon_audio_process_name
        I18n.t(
          "telegram.generation.humanized_process_names.audio.voices.#{CreateCartoonAudioRequest::VOICE}",
          locale:
        )
      end

      def cartoon_merge_process_name
        I18n.t(
          "telegram.generation.humanized_process_names.merge.#{CreateCartoonMergeRequest::PROCESSOR}",
          locale:
        )
      end
    end
  end
end
