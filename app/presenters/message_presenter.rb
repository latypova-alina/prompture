class MessagePresenter
  include Memery

  PRESENTERS = {
    CommandImageFromReferenceRequest: ImageFromReferenceMessagePresenter,
    CommandImageToVideoRequest: ImageToVideoMessagePresenter,
    CommandPromptToImageRequest: PromptToImageMessagePresenter,
    CommandPromptToVideoRequest: PromptToVideoMessagePresenter
  }.freeze

  def initialize(command_request)
    @command_request = command_request
  end

  private

  attr_reader :command_request

  memoize def corresponding_class
    return prompt_presenter if prompt_request?

    PRESENTERS[command_request.class].new(command_request)
  end

  def prompt_request?
    command_request.is_a?(CommandPromptToImageRequest) || command_request.is_a?(PromptToVideoRequest)
  end

  def prompt_presenter
    return FirstPromptMessagePresenter.new(command_request.prompt) unless command_request.extended_prompt

    ExtendedPromptMessagePresenter.new(request.extended_prompt)
  end
end
