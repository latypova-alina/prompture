module Generator
  module Media
    class TaskRetrieverDispatcher
      def self.call(...)
        new(...).call
      end

      def initialize(task_id:, button_request_id:, processor:)
        @task_id = task_id
        @button_request_id = button_request_id
        @processor = processor
      end

      def call
        case processor
        when *Generator::Processors::IMAGE
          Image::TaskRetrieverJob.perform_async(task_id, button_request_id, processor)
        when *Generator::Processors::VIDEO
          Video::TaskRetrieverJob.perform_async(task_id, button_request_id, processor)
        end
      end

      private

      attr_reader :task_id, :button_request_id, :processor
    end
  end
end
