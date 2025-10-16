module BuildGeminiImage
  class BuildGeminiImage
    include Interactor::Organizer

    organize CreateTask, CheckStatus
  end
end
