module Buttons
  module MediaInterface
    def build_processors_for_media
      media_processors.map do |processor|
        [
          button_for(media_scope, processor)
        ]
      end
    end

    private

    def media_processors
      COSTS[media_scope].keys - [:extend_prompt]
    end

    def media_scope
      raise NotImplementedError
    end
  end
end
