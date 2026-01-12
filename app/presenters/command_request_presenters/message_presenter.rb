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
      @command_request = command_request
    end

    private

    attr_reader :command_request

    memoize def corresponding_class
      PRESENTERS[command_request_class].new(command_request)
    end

    def command_request_class
      command_request.class.name.to_sym
    end
  end
end
