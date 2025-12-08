class MessagePresenter
  include Memery

  PRESENTERS = {
    ImageToVideoRequest: ImageToVideoMessagePresenter,
    ImageFromReferenceRequest: ImageFromReferenceMessagePresenter
  }.freeze

  def initialize(request)
    @request = request
  end

  private

  attr_reader :request

  memoize def corresponding_class
    return prompt_presenter if prompt_request?

    PRESENTERS[request.class].new(request)
  end

  def prompt_request?
    request.is_a?(PromptToImageRequest) || request.is_a?(PromptToVideoRequest)
  end

  def prompt_presenter
    return FirstPromptMessagePresenter.new(request.prompt) unless request.extended_prompt

    ExtendedPromptMessagePresenter.new(request.extended_prompt)
  end
end
