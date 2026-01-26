module ButtonHandler
  class HandleButton
    include Interactor::Organizer

    organize FindPrompt, FindParentRequest, CreateRequest, SendGenerationTask
  end
end
