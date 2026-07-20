module ScriptGenerator
  module Process
    class CartoonCharacterJob < ApplicationJob
      include JobErrorHandler

      def perform(chat_id)
        ScriptGenerator::ForCharacters::Processors::CartoonCharacter.call(chat_id:)
      rescue StandardError => e
        notify_script_generator_error(chat_id:, error: e)
      end
    end
  end
end
