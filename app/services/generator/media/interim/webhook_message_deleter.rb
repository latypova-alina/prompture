module Generator
  module Media
    module Interim
      class WebhookMessageDeleter
        include Memery

        def self.call(processor:, button_request_id:)
          new(processor:, button_request_id:).call
        end

        def initialize(processor:, button_request_id:)
          @processor = processor
          @button_request_id = button_request_id
        end

        def call
          return unless request_class

          MessageDeleter.call(request: request_class.find(button_request_id))
        end

        private

        attr_reader :processor, :button_request_id

        delegate :request_class, to: :message_request_identifier

        memoize :request_class

        def message_request_identifier
          MessageRequestIdentifier.new(processor:)
        end
      end
    end
  end
end
