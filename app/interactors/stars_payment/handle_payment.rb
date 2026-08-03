module StarsPayment
  class HandlePayment
    include Interactor::Organizer

    organize TokenHandler::FindOrCreateUser, ResolvePack, RecordPurchase, GrantCredits, NotifyUser
  end
end
