module Reviews
  module Survey
    module V1
      VERSION = 1
      MIN_TEXT_LENGTH = 10

      QUESTIONS = [
        Question.new(id: "rating", type: :rating, required: true),
        Question.new(
          id: "use_cases", type: :multi_choice, required: true, other: true, min_length: MIN_TEXT_LENGTH,
          options: %w[social_media cartoons work fun]
        ),
        Question.new(
          id: "features", type: :multi_choice, required: true,
          options: %w[image_generation video audio image_editing cartoon_scripts]
        ),
        Question.new(id: "missing", type: :text, required: true, min_length: MIN_TEXT_LENGTH),
        Question.new(id: "frustrations", type: :text, required: true, min_length: MIN_TEXT_LENGTH)
      ].freeze
    end
  end
end
