module ScriptGenerator
  class ProcessCartoonCharacter
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

    delegate :character_description, to: :cartoon_character_context

    memoize def cartoon_character_context
      ScriptGenerator::CartoonCharacterContext.new(chat_id:)
    end

    memoize def script_processor
      ScriptGenerator::ProcessScript.new(chat_id:, category: ContentCategory::CARTOON_CHARACTER)
    end
  end
end
