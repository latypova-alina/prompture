module Buttons
  class ForInitialPromptMessage < Base
    def build
      [
        [button_for(:prompt, :extend_prompt)],
        *processor_rows
      ]
    end

    private

    def processor_rows
      media_processors.map { |processor| [button_for(:generate_image, processor)] }
    end

    def media_processors
      COSTS[:generate_image].keys - [:extend_prompt]
    end
  end
end
