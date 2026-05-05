module ScriptProcessor
  class ProcessScript
    include Interactor::Organizer

    organize CreatePromptMessage, MediaGenerator::MessageHandler::NotifyUser, HandleFluxButton
  end
end
