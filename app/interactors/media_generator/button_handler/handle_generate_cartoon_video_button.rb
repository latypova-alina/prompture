module MediaGenerator
  module ButtonHandler
    class HandleGenerateCartoonVideoButton
      include Interactor::Organizer

      organize FindParentRequest, FindCommandRequest, ValidateCartoonScriptRequest,
               AcknowledgeCallbackQuery, CreateCartoonVideoRequest, DecrementBalance,
               SendGenerationTask
    end
  end
end
