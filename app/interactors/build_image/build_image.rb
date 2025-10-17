module BuildImage
  class BuildImage
    include Interactor::Organizer

    organize CreateTask, CheckStatus
  end
end
