module MediaGenerator
  module ButtonHandler
    class HandleProvidePromptButton
      include Interactor::Organizer

      organize FindParentRequest, MarkAwaitingVideoPrompt, RequestVideoPrompt
    end
  end
end
