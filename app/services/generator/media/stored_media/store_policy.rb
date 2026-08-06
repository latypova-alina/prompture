module Generator
  module Media
    module StoredMedia
      class StorePolicy
        def initialize(processor:)
          @processor = processor
        end

        def needs_to_be_stored?
          store_image? || store_audio? || store_video?
        end

        private

        attr_reader :processor

        def store_image?
          Generator::Processors::ALL_IMAGE.include?(processor)
        end

        def store_audio?
          Generator::Processors::AUDIO.include?(processor)
        end

        def store_video?
          Generator::Processors::VIDEO.include?(processor) ||
            Generator::Processors::MERGE.include?(processor)
        end
      end
    end
  end
end
