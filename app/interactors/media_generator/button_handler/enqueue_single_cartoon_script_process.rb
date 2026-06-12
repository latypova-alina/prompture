module MediaGenerator
  module ButtonHandler
    class EnqueueSingleCartoonScriptProcess
      include Interactor

      delegate :command_request, to: :context
      delegate :chat_id, to: :command_request

      def call
        ScriptGenerator::ProcessSingleCartoonScriptJob.perform_async(chat_id, category)
      end

      delegate :category, to: :command_request
    end
  end
end
