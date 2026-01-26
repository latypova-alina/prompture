module ButtonHandler
  class FindPrompt
    include Interactor
    include Memery

    delegate :tg_message_id, to: :context

    def call
      context.prompt = parent_message_request_prompt
    end

    private

    delegate :prompt, to: :parent_message_request, prefix: true

    memoize def parent_message_request
      ButtonParentMessage.find_by(tg_message_id:).request
    end
  end
end
