module ButtonHandler
  class HandleButton
    include Interactor::Organizer

    organize FindParentRequest, CreateRequest, SendGenerationTask
  end
end
