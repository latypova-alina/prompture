module Generator
  module Media
    class ErrorNotifierDispatcher
      include Memery

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
        when *Generator::Processors::IMAGE
          Generator::Image::ErrorNotifierJob.perform_async(button_request_id)
        when *Generator::Processors::VIDEO
          Generator::Video::ErrorNotifierJob.perform_async(button_request_id)
        end
      end
    end
  end
end
