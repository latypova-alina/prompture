module MessageHandler
  class HandleMessage
    include Interactor::Organizer

    organize UpdateRequest, NotifyUser
  end
end
