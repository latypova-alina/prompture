module ScriptGenerator
  class ProcessGeneratedScripts
    include Memery

    def self.call(...)
      new(...).call
    end

    def initialize(chat_id:, template_name: nil)
      @chat_id = chat_id
      @template_name = template_name
    end

    def call
      scripts.each { |script| process_script(script) }
      TelegramIntegration::DeleteBotTelegramMessage.call(request: User.find_by(chat_id:))
    end

    private

    attr_reader :chat_id, :template_name

    delegate :script_array, to: :script_context

    memoize def script_context
      ScriptGenerator::ScriptContext.new(chat_id:, template_name:)
    end

    memoize def script_processor
      ScriptGenerator::ProcessScript.new(chat_id:, category: script_category)
    end

    def script_category
      ContentCategory.normalize(template_name) || ContentCategory::TEMPLATE
    end

    def process_script(script)
      script_processor.call(script:)
    end

    def scripts
      script_array.split("\n\n").map(&:strip).reject(&:blank?)
    end
  end
end
