module ScriptGenerator
  module ForCharacters
    module Contexts
      class ForFoodCharacter < Base
        private

        def endpoint_path
          "/random_character"
        end
      end
    end
  end
end
