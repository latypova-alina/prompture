module Buttons
  class ForExtendedPromptMessage < Base
    def build
      [*build_processors_for_media]
    end

    private

    def scope
      "generate_image"
    end

    def type
      :images
    end
  end
end
