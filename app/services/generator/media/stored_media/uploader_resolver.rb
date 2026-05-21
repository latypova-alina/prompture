module Generator
  module Media
    module StoredMedia
      class UploaderResolver
        def initialize(processor:)
          @processor = processor
        end

        def uploader_class
          case processor
          when *Generator::Processors::VIDEO
            VideoUploader
          when *Generator::Processors::AUDIO
            AudioUploader
          else
            Uploader
          end
        end

        private

        attr_reader :processor
      end
    end
  end
end
