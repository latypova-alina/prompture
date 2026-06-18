module Generator
  module Media
    module Interim
      class CancellationHandler
        include Memery

        def self.call(generation_request:, callback_query_id:)
          new(generation_request:, callback_query_id:).call
        end

        def initialize(generation_request:, callback_query_id:)
          @generation_request = generation_request
          @callback_query_id = callback_query_id
        end

        def call
          cancel_request

          notify_result
        end

        private

        attr_reader :generation_request, :callback_query_id

        delegate :success?, :cancel_request, to: :canceller

        def notify_result
          CancellationResultNotifier.call(
            generation_request:,
            callback_query_id:,
            success: success?
          )
        end

        memoize def canceller
          Generator::Media::FalRequestCanceller.new(generation_request)
        end
      end
    end
  end
end
