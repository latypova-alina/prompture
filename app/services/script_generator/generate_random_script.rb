module ScriptGenerator
  class GenerateRandomScript
    include Memery

    def self.call(...)
      new(...).call
    end

    def initialize(chat_id:)
      @chat_id = chat_id
    end

    def call
      script_array.each { |script| process_script(script) }
    end

    private

    attr_reader :chat_id

    delegate :script_array, to: :script_context

    memoize def script_context
      ScriptGenerator::ScriptContext.new(chat_id:)
    end

    memoize def script_processor
      ScriptGenerator::ProcessScript.new(chat_id:)
    end

    def process_script(script)
      script_processor.call(script:)
    end
  end
end
