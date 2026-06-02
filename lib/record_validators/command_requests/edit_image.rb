module RecordValidators
  module CommandRequests
    class EditImage
      def initialize(command_request:, message_text:, picture_id:)
        @command_request = command_request
        @message_text = message_text
        @picture_id = picture_id
      end

      def validate
        raise MessageTypeError unless valid_message_type?
        raise ImageNotReadyError unless source_image_ready?
      end

      private

      attr_reader :command_request, :message_text, :picture_id

      def valid_message_type?
        prompt_message? && no_prompt_saved_yet? && source_image_received?
      end

      def source_image_ready?
        command_request.latest_image_message&.resolved_image_url.present?
      end

      def prompt_message?
        message_text.present? && picture_id.blank?
      end

      def no_prompt_saved_yet?
        command_request.prompt.blank?
      end

      def source_image_received?
        command_request.latest_image_message.present?
      end
    end
  end
end
