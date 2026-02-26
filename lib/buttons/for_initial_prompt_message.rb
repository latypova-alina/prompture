module Buttons
  class ForInitialPromptMessage < Base
    include MediaInterface

    def build
      [
        [button_for(:prompt, :extend_prompt)],
        *build_processors_for_media
      ]
    end

    private

    def media_scope
      "generate_image"
    end
  end
end
