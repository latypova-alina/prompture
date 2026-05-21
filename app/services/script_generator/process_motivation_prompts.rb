module ScriptGenerator
  class ProcessMotivationPrompts
    include Memery

    def self.call(...)
      new(...).call
    end

    def initialize(chat_id:)
      @chat_id = chat_id
    end

    def call
      prompts.each { |prompt| process_prompt(prompt) }
    end

    private

    attr_reader :chat_id

    delegate :prompts, to: :motivation_prompt_context

    memoize def motivation_prompt_context
      ScriptGenerator::MotivationPromptContext.new(chat_id:)
    end

    memoize def script_processor
      ScriptGenerator::ProcessScript.new(chat_id:, category: ContentCategory::MOTIVATION)
    end

    def process_prompt(prompt)
      script_processor.call(script: prompt)
    end
  end
end
