module SetLocale
  module ButtonHandler
    class HandleButton
      include Interactor::Organizer

      organize UpdateUser, NotifyUser
    end
  end
end
