module AudioScriptProcessor
  class ProcessScript
    include Interactor::Organizer

    organize ScriptProcessor::CreatePromptMessage,
             MediaGenerator::MessageHandler::NotifyUser,
             AudioScriptProcessor::HandleAudioButton
  end
end
