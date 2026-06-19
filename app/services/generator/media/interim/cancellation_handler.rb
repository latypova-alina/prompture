module Generator
  module Media
    module Interim
      class CancellationHandler
        def self.call(generation_request:, callback_query_id:)
          new(generation_request:, callback_query_id:).call
        end

        def initialize(generation_request:, callback_query_id:)
          @generation_request = generation_request
          @callback_query_id = callback_query_id
        end

        def call
          cancel_generation

          notify_success
        end

        private

        attr_reader :generation_request, :callback_query_id

        def cancel_generation
          generation_request.update!(status: "CANCELLED")

          MessageDeleter.call(request: generation_request)
        end

        def notify_success
          CancellationResultNotifier.call(
            generation_request:,
            callback_query_id:,
            success: true
          )
        end
      end
    end
  end
end
