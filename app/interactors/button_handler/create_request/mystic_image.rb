module ButtonHandler
  module CreateRequest
    class MysticImage
      include Interactor

      delegate :chat_id, :parent_request, to: :context

      def call
        ::ButtonImageProcessorRequest.create!(
          chat_id:,
          status: "PENDING",
          prompt:,
          parent_request:,
          processor: "mystic_image"
        )
      end

      delegate :prompt, to: :parent_request
    end
  end
end
