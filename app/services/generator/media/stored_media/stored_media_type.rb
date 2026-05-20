module Generator
  module Media
    module StoredMedia
      class StoredMediaType
        include Memery

        def initialize(processor:, media_url:, button_request_id:)
          @processor = processor
          @media_url = media_url
          @button_request_id = button_request_id
        end

        def needs_to_be_stored?
          image_processor? || audio?
        end

        def uploader
          if audio?
            AudioUploader.new(media_url:, record: audio_request)
          else
            Uploader.new(media_url:, record: image_request)
          end
        end

        private

        attr_reader :processor, :media_url, :button_request_id

        def audio?
          Generator::Processors::AUDIO.include?(processor)
        end

        def image_processor?
          Generator::Processors::IMAGE.include?(processor)
        end

        memoize def image_request
          ButtonImageProcessingRequest.find(button_request_id)
        end

        memoize def audio_request
          ButtonAudioProcessingRequest.find(button_request_id)
        end
      end
    end
  end
end
