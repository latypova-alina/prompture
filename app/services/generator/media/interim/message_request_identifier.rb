module Generator
  module Media
    module Interim
      class MessageRequestIdentifier
        INTERIM_PROCESSORS = (
          Generator::Processors::ALL_IMAGE + Generator::Processors::VIDEO
        ).freeze

        def initialize(processor:)
          @processor = processor
        end

        def request_class
          return unless INTERIM_PROCESSORS.include?(processor)

          if Generator::Processors::ALL_IMAGE.include?(processor)
            ButtonImageProcessingRequest
          else
            ButtonVideoProcessingRequest
          end
        end

        private

        attr_reader :processor
      end
    end
  end
end
