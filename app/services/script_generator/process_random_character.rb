module ScriptGenerator
  class ProcessRandomCharacter
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

    memoize def character_context
      ScriptGenerator::CharacterContext.new(chat_id:)
    end

    memoize def script_processor
      ScriptGenerator::ProcessScript.new(chat_id:)
    end
  end
end
