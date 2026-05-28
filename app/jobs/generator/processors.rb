module Generator
  module Processors
    PROMPT_EXTENSION = "extend_prompt".freeze

    FAL_IMAGE = %w[
      flux_image
      nano_banana_image
    ].freeze

    IMAGE = [
      *FAL_IMAGE,
      "imagen_image"
    ].freeze

    VIDEO = %w[
      kling_2_1_pro_image_to_video
      wan_2_2_image_to_video
    ].freeze

    AUDIO = %w[
      elevenlabs_turbo_v2_5_audio
    ].freeze
  end
end
