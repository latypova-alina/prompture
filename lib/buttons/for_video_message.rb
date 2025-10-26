module Buttons
  class ForVideoMessage < Base
    def self.buttons
      [
        [
          {
            "text": "Kling Pro 2.1 (0.42€)",
            "callback_data": "kling_2_1_pro_image_to_video"
          }
        ]
      ]
    end
  end
end
