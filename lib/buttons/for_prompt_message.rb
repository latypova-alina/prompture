module Buttons
  class ForPromptMessage < Base
    def self.buttons
      [
        [
          {
            "text": "Mystic (Realistic, 0.1€)",
            "callback_data": "mystic_image"
          }
        ]
      ]
    end
  end
end
