module MediaGenerator
  module ButtonHandler
    class HandleGenerateCartoonVideoButton
      include Interactor::Organizer

      organize FindParentRequest, FindCommandRequest, ValidateCartoonScriptRequest,
               CreateCartoonVideoRequest, DecrementBalance, NotifyProcessingStarted,
               SendGenerationTask
    end
  end
end
