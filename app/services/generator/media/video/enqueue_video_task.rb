module Generator
  module Media
    module Video
      class EnqueueVideoTask
        TASK_CREATION_DELAY = 3.seconds

        def self.call(...)
          new(...).call
        end

        def initialize(request)
          @request = request
        end

        def call
          Generator::Media::Interim::MessageSender.call(request:)

          TaskCreatorJob.perform_in(TASK_CREATION_DELAY, request.id)
        end

        private

        attr_reader :request
      end
    end
  end
end
