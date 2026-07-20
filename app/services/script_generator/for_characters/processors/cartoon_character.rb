module ScriptGenerator
  module ForCharacters
    module Processors
      class CartoonCharacter < Base
        private

        def character_context_class
          ScriptGenerator::ForCharacters::Contexts::ForCartoonCharacter
        end

        def script_category
          ContentCategory::CARTOON_CHARACTER
        end
      end
    end
  end
end
