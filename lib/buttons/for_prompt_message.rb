module Buttons
  class ForPromptMessage < Base
    def self.buttons
      [
        [
          {
            "text": "Mystic (0.1€)",
            "callback_data": "mystic_image"
          }
        ],
        [
          {
            "text": "Gemini (0.04€)",
            "callback_data": "gemini_image"
          }
        ]
      ]
    end
  end
end
