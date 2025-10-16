module Buttons
  class ForRepeatedImageMessage < Base
    def self.buttons
      [
        [
          {
            "text": "Regenerate Mystic (Realistic, 0.1€)",
            "callback_data": "mystic_image"
          }
        ]
      ]
    end
  end
end
