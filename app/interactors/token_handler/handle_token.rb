module TokenHandler
  class HandleToken
    include Interactor::Organizer

    organize FindOrCreateUser, NotifyAdminOfNewUser, VerifyToken, UpdateToken, GrantCredits, NotifyUser
  end
end
