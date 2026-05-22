module ScriptGenerator
  module ForMotivation
    class MotivationPromptContext < PromptsBaseContext
      private

      memoize def response
        connection.get("/motivation_prompt")
      end
    end
  end
end
