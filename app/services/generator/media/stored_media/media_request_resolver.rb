module Generator
  module Media
    module StoredMedia
      class MediaRequestResolver
        include Memery

        def initialize(processor:, button_request_id:)
          @processor = processor
          @button_request_id = button_request_id
        end

        memoize def media_request
          request_class.find(button_request_id)
        end

        private

        attr_reader :processor, :button_request_id

        def request_class
          case processor
          when *Generator::Processors::VIDEO
            ButtonVideoProcessingRequest
          when *Generator::Processors::AUDIO
            ButtonAudioProcessingRequest
          else
            ButtonImageProcessingRequest
          end
        end
      end
    end
  end
end
