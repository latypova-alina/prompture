module TokenHandler
  class NotifyAdminOfNewUser
    include Interactor

    delegate :user, to: :context

    def call
      return unless user.previously_new_record?

      AdminNewUserNotifierJob.perform_async
    end
  end
end
