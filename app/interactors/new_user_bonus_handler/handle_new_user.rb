module NewUserBonusHandler
  class HandleNewUser
    include Interactor::Organizer

    organize CheckEligibility, GrantBonus, NotifyUser
  end
end
