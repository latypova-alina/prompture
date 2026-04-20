module Generator
  module Processors
    PROMPT_EXTENSION = "extend_prompt".freeze

    IMAGE = %w[
      mystic_image
      flux_image
      gemini_image
      imagen_image
    ].freeze

    VIDEO = %w[
      kling_2_1_pro_image_to_video
      seedance_1_5_pro_image_to_video
      wan_2_2_image_to_video
    ].freeze
  end
end
