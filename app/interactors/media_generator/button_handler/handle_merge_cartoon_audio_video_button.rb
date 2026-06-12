module MediaGenerator
  module ButtonHandler
    class HandleMergeCartoonAudioVideoButton
      include Interactor::Organizer

      organize FindParentRequest, FindCommandRequest, ValidateCartoonAudioMergeRequest,
               AcknowledgeCallbackQuery, CreateCartoonMergeRequest, DecrementBalance,
               SendGenerationTask
    end
  end
end
