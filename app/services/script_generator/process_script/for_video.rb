module ScriptGenerator
  module ProcessScript
    class ForVideo < Base
      private

      def command_request_class
        CommandPromptToVideoRequest
      end
    end
  end
end
