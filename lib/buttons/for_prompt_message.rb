module Buttons
  class ForPromptMessage < Base
    # rubocop:disable Metrics/MethodLength
    def self.buttons
      [
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
