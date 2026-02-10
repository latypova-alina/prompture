module RecordValidators
  module CommandRequests
    class PromptToImage < Base
      private

      def valid_message_type?
        message_text.present?
      end
    end
  end
end
