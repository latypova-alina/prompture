module ButtonHandler
  class HandleButton
    include Interactor::Organizer

    organize FindParentRequest, FindCommandRequest, CreateRequest, DecrementBalance, NotifyProcessingStarted,
             SendGenerationTask
  end
end
