module MediaGenerator
  module ButtonHandler
    class HandleMergeCartoonAudioVideoButton
      include Interactor::Organizer

      organize FindParentRequest, SetCartoonMergeContext, FindCommandRequest, ValidateCartoonAudioMergeRequest,
               AcknowledgeCallbackQuery, CreateCartoonMergeRequest, DecrementBalance,
               SendGenerationTask
    end
  end
end
