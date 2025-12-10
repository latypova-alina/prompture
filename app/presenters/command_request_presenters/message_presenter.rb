module CommandRequestPresenters
  class MessagePresenter < ::BasePresenter
    include Memery

    PRESENTERS = {
      CommandImageFromReferenceRequest: ImageFromReferenceMessagePresenter,
      CommandImageToVideoRequest: ImageToVideoMessagePresenter,
      CommandPromptToImageRequest: PromptRequestPresenter,
      CommandPromptToVideoRequest: PromptRequestPresenter
    }.freeze

    def initialize(command_request)
      super()

      @command_request = command_request
    end

    private

    attr_reader :command_request

    memoize def corresponding_class
      PRESENTERS[command_request.class].new(command_request)
    end
  end
end
