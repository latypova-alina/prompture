module Generator
  module Media
    class CancelledGenerationDispatcher
      def self.call(...)
        new(...).call
      end

      def initialize(processor:, button_request_id:)
        @processor = processor
        @button_request_id = button_request_id
      end

      attr_reader :processor, :button_request_id

      def call
        case processor
        when *Generator::Processors::ALL_IMAGE
          Image::CancellationNotifierJob.perform_async(button_request_id)
        when *Generator::Processors::VIDEO
          Video::CancellationNotifierJob.perform_async(button_request_id)
        end
      end
    end
  end
end
