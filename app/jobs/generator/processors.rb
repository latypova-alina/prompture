module Generator
  module Processors
    PROMPT_EXTENSION = "extend_prompt".freeze

    IMAGE = %w[
      flux_image
      nano_banana_image
      imagen_image
    ].freeze

    EDIT_IMAGE = %w[
      nano_banana_edit_image
    ].freeze

    ALL_IMAGE = (IMAGE + EDIT_IMAGE).freeze

    VIDEO = %w[
      kling_2_1_pro_image_to_video
      seedance_2_0_image_to_video
    ].freeze

    AUDIO = %w[
      elevenlabs_turbo_v2_5_audio
    ].freeze
  end
end
