module Generator
  module Media
    module StoredMedia
      class StorePolicy
        def initialize(processor:, command_request:)
          @processor = processor
          @command_request = command_request
        end

        def needs_to_be_stored?
          store_image? || store_audio? || store_video?
        end

        private

        attr_reader :processor, :command_request

        def store_image?
          Generator::Processors::ALL_IMAGE.include?(processor)
        end

        def store_audio?
          Generator::Processors::AUDIO.include?(processor)
        end

        def store_video?
          video_processor? && ContentCategory.store_video?(command_request.try(:category))
        end

        def video_processor?
          Generator::Processors::VIDEO.include?(processor)
        end
      end
    end
  end
end
