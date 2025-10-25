module Buttons
  class ForImageMessage < ForPromptMessage
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
        ],
        [
          {
            "text": "Kling Pro 2.1 (0.42€)",
            "callback_data": "kling_2_1_pro_image_to_video"
          }
        ]
      ]
    end
    # rubocop:enable Metrics/MethodLength
  end
end
