module ScriptGenerator
  class ProcessCharacterBase
    include Memery

    def self.call(...)
      new(...).call
    end

    def initialize(chat_id:)
      @chat_id = chat_id
    end

    def call
      script_processor.call(script: character_description)
    end

    private

    attr_reader :chat_id

    delegate :character_description, to: :character_context

    def character_context_class
      raise NotImplementedError, "#{self.class.name} must implement #character_context_class"
    end

    def script_category
      raise NotImplementedError, "#{self.class.name} must implement #script_category"
    end

    memoize def character_context
      character_context_class.new(chat_id:)
    end

    memoize def script_processor
      ScriptGenerator::ProcessScript::ForVideo.new(chat_id:, category: script_category)
    end
  end
end
