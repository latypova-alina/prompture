module TokenHandler
  class HandleToken
    include Interactor::Organizer

    organize VerifyToken, FindOrCreateUser, UpdateToken, CreateOrUpdateBalance, NotifyUser
  end
end
