module TokenHandler
  class HandleToken
    include Interactor::Organizer

    organize VerifyToken, FindOrCreateUser, UpdateToken, GrantCredits, NotifyUser
  end
end
