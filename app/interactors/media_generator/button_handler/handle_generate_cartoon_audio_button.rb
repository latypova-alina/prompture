module MediaGenerator
  module ButtonHandler
    class HandleGenerateCartoonAudioButton
      include Interactor::Organizer

      organize FindParentRequest, FindCommandRequest, ValidateCartoonVideoScriptRequest,
               CreateCartoonAudioRequest, DecrementBalance, NotifyProcessingStarted,
               SendGenerationTask
    end
  end
end
