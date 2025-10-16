module Buttons
  class ForRepeatedImageMessage < Base
    def self.buttons
      [
        [
          {
            "text": "Regenerate Mystic (0.1€)",
            "callback_data": "mystic_image"
          }
        ],
        [
          {
            "text": "Gemini (0.4€)",
            "callback_data": "gemini_image"
          }
        ]
      ]
    end
  end
end
