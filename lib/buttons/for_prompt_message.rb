module Buttons
  class ForPromptMessage
    JSON_FILE_PATH = "config/keyboards/for_prompt_message.json".freeze

    def self.buttons
      JSON.parse(File.read(JSON_FILE_PATH))["inline_keyboard"]
    end
  end
end
