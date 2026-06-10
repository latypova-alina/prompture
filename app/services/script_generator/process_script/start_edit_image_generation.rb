module ScriptGenerator
  module ProcessScript
    class StartEditImageGeneration
      PROCESSOR = "nano_banana_edit_image".freeze

      def self.call(...)
        new(...).call
      end

      def initialize(command_request:)
        @command_request = command_request
      end

      def call
        raise generation_result.error if generation_result.failure?
      end

      private

      attr_reader :command_request

      def generation_result
        @generation_result ||= MediaGenerator::MessageHandler::EditImageMessageHandler::StartGeneration.call(
          command_request:,
          button_request: PROCESSOR
        )
      end
    end
  end
end
