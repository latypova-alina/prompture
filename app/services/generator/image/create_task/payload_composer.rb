module Generator
  module Image
    module CreateTask
      class PayloadComposer
        def initialize(request, strategy)
          @request = request
          @strategy = strategy
        end

        def final_payload
          strategy.payload.reverse_merge(webhook_url:)
        end

        private

        attr_reader :request, :strategy

        delegate :processor, to: :request

        def webhook_url
          Generator::WebhookUrlBuilder.new(processor:, button_request_id: request.id)
                                      .webhook_url
        end
      end
    end
  end
end
