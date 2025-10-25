module BuildVideo
  class BuildVideo
    include Interactor::Organizer

    organize CreateTask, CheckStatus
  end
end
