module Buttons
  class ForInitialPromptMessage
    BUTTONS = [
      [
        {
          "text": "Extend prompt",
          "callback_data": "extend_prompt"
        }
      ],
      [
        {
          "text": "Gemini (1 credit)",
          "callback_data": "gemini_image"
        }
      ],
      [
        {
          "text": "Imagen3 (1 credit)",
          "callback_data": "imagen_image"
        }
      ],
      [
        {
          "text": "Mystic (2 credits)",
          "callback_data": "mystic_image"
        }
      ]
    ].freeze
  end
end
