module MediaGenerator
  module ButtonHandler
    class HandleButton
      include Interactor::Organizer

      organize FindParentRequest, FindCommandRequest, CreateRequest, DecrementBalance, NotifyProcessingStarted,
               SendGenerationTask, ClearInlineKeyboard
    end
  end
end
