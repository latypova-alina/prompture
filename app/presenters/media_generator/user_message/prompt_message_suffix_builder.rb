module MediaGenerator
  module UserMessage
    class PromptMessageSuffixBuilder
      SUFFIX_KEYS = {
        CommandPromptToAudioRequest => "telegram_webhooks.message.prompt_suffix_audio"
      }.freeze

      DEFAULT_SUFFIX_KEY = "telegram_webhooks.message.prompt_suffix"

      def initialize(command_request:)
        @command_request = command_request
      end

      def suffix_key
        SUFFIX_KEYS.fetch(command_request.class, DEFAULT_SUFFIX_KEY)
      end

      private

      attr_reader :command_request
    end
  end
end
