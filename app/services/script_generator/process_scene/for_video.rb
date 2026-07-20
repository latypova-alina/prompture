module ScriptGenerator
  module ProcessScene
    class ForVideo < Base
      private

      def command_request_class
        CommandPromptToVideoRequest
      end
    end
  end
end
