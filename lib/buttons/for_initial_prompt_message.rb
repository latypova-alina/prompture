module Buttons
  class ForInitialPromptMessage < Base
    # rubocop:disable Metrics/MethodLength
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
            "text": "Gemini (0.035€)",
            "callback_data": "gemini_image"
          }
        ],
        [
          {
            "text": "Imagen3 (0.04€)",
            "callback_data": "imagen_image"
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
    # rubocop:enable Metrics/MethodLength
  end
end
