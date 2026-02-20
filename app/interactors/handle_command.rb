class HandleCommand
  include Interactor
  include Memery

  delegate :command, :chat_id, to: :context

  HANDLERS = {
    "prompt_to_image" => CommandPromptToImageRequest,
    "prompt_to_video" => CommandPromptToVideoRequest,
    "image_to_video" => CommandImageToVideoRequest,
    "image_from_reference" => CommandImageFromReferenceRequest
  }.freeze

  def call
    context.fail!(error: CommandUnknownError) unless HANDLERS.key?(command)

    HANDLERS[command].create!(chat_id:, user:)
  end

  private

  memoize def user
    User.find_by!(chat_id:)
  end
end
