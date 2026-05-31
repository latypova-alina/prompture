module ScriptGenerator
  class ProcessBrainrotCharacter < ProcessCharacterBase
    private

    def character_context_class
      ScriptGenerator::BrainrotCharacterContext
    end

    def script_category
      ContentCategory::BRAINROT_CHARACTER
    end
  end
end
