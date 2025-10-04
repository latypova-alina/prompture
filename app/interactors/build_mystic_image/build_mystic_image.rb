module BuildMysticImage
  class BuildMysticImage
    include Interactor::Organizer

    organize CreateTask, CheckStatus
  end
end
