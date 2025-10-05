module Buttons
  class ForRepeatedImageMessage < Base
    JSON_FILE_PATH = "config/keyboards/for_repeated_image_message.json".freeze

    def self.buttons
      JSON.parse(File.read(JSON_FILE_PATH))["inline_keyboard"]
    end
  end
end
