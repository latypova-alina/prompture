module ButtonHandler
  class HandleButton
    include Interactor::Organizer

    organize FindParentRequest, FindCommandRequest, CreateRequest, DecrementBalance, SendGenerationTask
  end
end
