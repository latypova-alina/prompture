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
          return Notifier::Outdated.call(generation_request:, callback_query_id:) if already_sent_to_fal?

          cancel_generation

          Notifier::Success.call(generation_request:, callback_query_id:)
        end

        private

        attr_reader :generation_request, :callback_query_id

        def already_sent_to_fal?
          generation_request.respond_to?(:fal_request_id) &&
            generation_request.fal_request_id.present?
        end

        def cancel_generation
          generation_request.update!(status: "CANCELLED")

          MessageDeleter.call(request: generation_request)
        end
      end
    end
  end
end
