module Buttons
  class ForExtendedPromptMessage < Base
    def build
      processor_rows
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
