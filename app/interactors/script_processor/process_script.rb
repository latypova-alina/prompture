module ScriptProcessor
  class ProcessScript
    include Interactor::Organizer

    organize CreatePromptMessage, CreateBotTelegramMessage, HandleFluxButton
  end
end
