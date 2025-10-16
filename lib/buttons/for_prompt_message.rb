module Buttons
  class ForPromptMessage < Base
    def self.buttons
      [
        [
          {
            "text": "Gemini (0.04€)",
            "callback_data": "gemini_image"
          }
        ],
        [
          {
            "text": "Mystic (0.1€)",
            "callback_data": "mystic_image"
          }
        ]
      ]
    end
  end
end
