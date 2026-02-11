module TokenHandler
  class HandleToken
    include Interactor::Organizer

    organize VerifyToken, FindOrCreateUser, UpdateToken, UpdateOrCreateBalance
  end
end
