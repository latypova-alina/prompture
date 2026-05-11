module ScriptGenerator
  class PerformJob
    include Interactor

    delegate :chat_id, :template_name, to: :context

    def call
      ScriptGenerator::GenerateScriptJob.perform_async(chat_id, template_name)
    end
  end
end
