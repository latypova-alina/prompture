module ScriptGenerator
  class ProcessBrainrotCharacter
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

    delegate :character_description, to: :brainrot_character_context

    memoize def brainrot_character_context
      ScriptGenerator::BrainrotCharacterContext.new(chat_id:)
    end

    memoize def script_processor
      ScriptGenerator::ProcessScript.new(chat_id:, category: ContentCategory::BRAINROT_CHARACTER)
    end
  end
end
