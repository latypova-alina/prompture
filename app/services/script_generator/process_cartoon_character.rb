module ScriptGenerator
  class ProcessCartoonCharacter < ProcessCharacterBase
    private

    def character_context_class
      ScriptGenerator::CartoonCharacterContext
    end

    def script_category
      ContentCategory::CARTOON_CHARACTER
    end
  end
end
