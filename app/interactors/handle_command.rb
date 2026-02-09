class HandleCommand
  include Interactor

  delegate :command, :chat_id, to: :context

  HANDLERS = {
    "prompt_to_image" => CommandPromptToImageRequest,
    "prompt_to_video" => CommandPromptToVideoRequest,
    "image_to_video" => CommandImageToVideoRequest,
    "image_from_reference" => CommandImageFromReferenceRequest
  }.freeze

  def call
    context.fail!(error: CommandUnknownError) unless HANDLERS.key?(command)

    HANDLERS[command].create!(chat_id:)
  end
end
