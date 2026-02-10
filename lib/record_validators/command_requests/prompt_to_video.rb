module RecordValidators
  module CommandRequests
    class PromptToVideo < Base
      private

      def valid_message_type?
        message_text.present?
      end
    end
  end
end
