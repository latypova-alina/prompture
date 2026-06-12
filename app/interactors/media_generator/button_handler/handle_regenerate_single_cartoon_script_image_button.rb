module MediaGenerator
  module ButtonHandler
    class HandleRegenerateSingleCartoonScriptImageButton
      include Interactor::Organizer

      organize FindParentRequest, FindCommandRequest, ValidateCartoonScriptImageRequest,
               AcknowledgeCallbackQuery, EnqueueSingleCartoonScriptProcess
    end
  end
end
