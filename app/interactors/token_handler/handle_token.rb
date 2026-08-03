module TokenHandler
  class HandleToken
    include Interactor::Organizer

    organize FindOrCreateUser, VerifyToken, UpdateToken, GrantCredits, NotifyUser
  end
end
