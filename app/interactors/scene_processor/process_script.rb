module SceneProcessor
  class ProcessScript
    include Interactor::Organizer

    organize CreatePromptMessage, MediaGenerator::MessageHandler::NotifyUser, HandleImageGenerationButton
  end
end
