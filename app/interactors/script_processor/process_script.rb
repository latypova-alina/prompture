module ScriptProcessor
  class ProcessScript
    include Interactor::Organizer

    organize CreatePromptMessage, MediaGenerator::MessageHandler::NotifyUser, HandleImageGenerationButton
  end
end
