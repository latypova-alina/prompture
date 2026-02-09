module ButtonHandler
  class HandleButton
    include Interactor::Organizer

    organize FindParentRequest, FindCommandRequest, CreateRequest, SendGenerationTask
  end
end
