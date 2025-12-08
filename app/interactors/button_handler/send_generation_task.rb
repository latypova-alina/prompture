module ButtonHandler
  class SendGenerationTask
    include Interactor

    delegate :chat_id, :button_request, :chat_id, :image_url, to: :context

    def call
      Generator::TaskCreatorSelectorJob.perform_async(prompt, image_url, button_request, chat_id)
    end

    private

    delegate :prompt, to: :parent_request
  end
end
