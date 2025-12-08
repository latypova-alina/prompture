module ButtonHandler
  module CreateRequest
    class ExtendPrompt
      include Interactor
      include Memery

      delegate :chat_id, :parent_request, to: :context

      def call
        ::ButtonExtendPromptRequest.create!(
          chat_id:,
          status: "PENDING",
          prompt:,
          parent_request:
        )
      end

      private

      delegate :prompt, to: :parent_request
    end
  end
end
