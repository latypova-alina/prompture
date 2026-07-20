module AudioScriptProcessor
  class ProcessScript
    include Interactor::Organizer

    organize SceneProcessor::CreatePromptMessage,
             MediaGenerator::MessageHandler::NotifyUser,
             AudioScriptProcessor::HandleAudioButton
  end
end
