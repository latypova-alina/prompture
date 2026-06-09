module ScriptGenerator
  module ProcessScript
    class ForImage < Base
      private

      def command_request_class
        CommandPromptToImageRequest
      end
    end
  end
end
