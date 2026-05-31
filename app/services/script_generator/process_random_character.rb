module ScriptGenerator
  class ProcessRandomCharacter < ProcessCharacterBase
    private

    def character_context_class
      ScriptGenerator::CharacterContext
    end

    def script_category
      ContentCategory::RANDOM_CHARACTER
    end
  end
end
