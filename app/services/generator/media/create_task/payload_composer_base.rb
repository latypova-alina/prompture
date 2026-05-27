module Generator
  module Media
    module CreateTask
      class PayloadComposerBase
        def initialize(request, strategy)
          @request = request
          @strategy = strategy
        end

        def final_payload
          strategy.payload.merge(webhook_param_name => webhook_url)
        end

        private

        attr_reader :request, :strategy

        delegate :processor, to: :request

        delegate :webhook_url, to: :webhook_url_builder

        def webhook_param_name
          return strategy.webhook_param_name if strategy.respond_to?(:webhook_param_name)

          :webhook_url
        end

        def webhook_url_builder
          Generator::Media::WebhookUrlBuilder.new(processor:, button_request_id: request.id)
        end
      end
    end
  end
end
