module Generator
  module Media
    module Interim
      class MessageSender
        include LocaleSupport
        include Memery

        def self.call(request:)
          new(request:).call
        end

        def initialize(request:)
          @request = request
        end

        def call
          with_locale(request.locale) do
            request.update!(interim_tg_message_id: tg_message_id)
          end
        end

        private

        attr_reader :request

        delegate :tg_message_id, to: :response_sender

        memoize def response_sender
          ResponseSender.new(request:)
        end
      end
    end
  end
end
