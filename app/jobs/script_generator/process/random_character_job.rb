module ScriptGenerator
  module Process
    class RandomCharacterJob < ApplicationJob
      include JobErrorHandler

      def perform(chat_id)
        ScriptGenerator::ForCharacters::Processors::FoodCharacter.call(chat_id:)
      rescue StandardError => e
        notify_script_generator_error(chat_id:, error: e)
      end
    end
  end
end
