module Generator
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
        Generator::Image::TaskRetrieverJob.perform_async(task_id, button_request_id, processor)
      when *Generator::Processors::VIDEO
        Generator::Video::TaskRetrieverJob.perform_async(task_id, button_request_id, processor)
      end
    end

    private

    attr_reader :task_id, :button_request_id, :processor
  end
end
