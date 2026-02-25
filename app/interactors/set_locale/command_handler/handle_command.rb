module SetLocale
  module CommandHandler
    class HandleCommand
      include Interactor::Organizer

      organize UpdateUser, NotifyUser
    end
  end
end
