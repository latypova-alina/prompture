module MessageHandler
  class HandleMessage
    include Interactor::Organizer

    organize ParseUserMessage, SelectUpdateStrategy, NotifyUser
  end
end
