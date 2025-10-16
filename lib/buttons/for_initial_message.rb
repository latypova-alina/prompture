module Buttons
  class ForInitialMessage < Base
    def self.buttons
      [
        [
          {
            "text": "Extend prompt",
            "callback_data": "extend_prompt"
          }
        ],
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
