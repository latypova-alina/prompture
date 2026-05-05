module ScriptGenerator
  class ScriptContext
    def initialize(chat_id:)
      @chat_id = chat_id
    end

    def script_context
      result = ScriptGenerator::GenerateScript.call(chat_id:)

      raise result.error if result.failure?

      result
    end

    attr_reader :chat_id
  end
end
