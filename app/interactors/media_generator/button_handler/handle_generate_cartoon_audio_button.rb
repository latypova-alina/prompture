module MediaGenerator
  module ButtonHandler
    class HandleGenerateCartoonAudioButton
      include Interactor::Organizer

      organize FindParentRequest, FindCommandRequest, ValidateCartoonVideoScriptRequest,
               AcknowledgeCallbackQuery, CreateCartoonAudioRequest, DecrementBalance,
               SendGenerationTask
    end
  end
end
