module Buttons
  class ForExtendedPromptMessage < Base
    include MediaInterface

    def build
      [*build_processors_for_media]
    end

    private

    def media_scope
      "generate_image"
    end
  end
end
