module ButtonHandler
  class FindParentRequest
    include Interactor
    include Memery

    PARENT_MODELS = {
      "prompt_to_image" => CommandPromptToImageRequest,
      "prompt_to_video" => CommandPromptToVideoRequest,
      "image_to_video" => CommandImageToVideoRequest,
      "image_from_reference" => CommandImageFromReferenceRequest
    }.freeze

    delegate :chat_id, :command, to: :context

    def call
      context.parent_request = parent_request
    end

    private

    memoize def parent_request
      PARENT_MODELS[command].where(chat_id:).order(created_at: :desc).first
    end
  end
end
