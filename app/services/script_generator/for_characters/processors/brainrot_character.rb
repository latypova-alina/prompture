module ScriptGenerator
  module ForCharacters
    module Processors
      class BrainrotCharacter < Base
        private

        def character_context_class
          ScriptGenerator::ForCharacters::Contexts::ForBrainrotCharacter
        end

        def script_category
          ContentCategory::BRAINROT_CHARACTER
        end
      end
    end
  end
end
