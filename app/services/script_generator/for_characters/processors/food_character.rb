module ScriptGenerator
  module ForCharacters
    module Processors
      class FoodCharacter < Base
        private

        def character_context_class
          ScriptGenerator::ForCharacters::Contexts::ForFoodCharacter
        end

        def script_category
          ContentCategory::RANDOM_CHARACTER
        end
      end
    end
  end
end
