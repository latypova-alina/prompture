module Generator
  module Media
    module CreateTask
      # Saves the exact payload sent to fal (final prompt after extension and enhancers, image URLs,
      # model params) on the button request. The webhook URL carries a signed token, so it's left out.
      class PayloadRecorder
        def self.call(...)
          new(...).call
        end

        def initialize(request:, payload:)
          @request = request
          @payload = payload
        end

        def call
          request.update!(fal_payload: payload.to_h.with_indifferent_access.except(:webhook_url))
        end

        private

        attr_reader :request, :payload
      end
    end
  end
end
