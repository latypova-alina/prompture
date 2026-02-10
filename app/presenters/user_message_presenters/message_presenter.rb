module UserMessagePresenters
  class MessagePresenter < ::BasePresenter
    include Memery

    PRESENTERS = {
      PromptMessage: PromptMessagePresenter
    }.freeze

    def initialize(user_message:, message: nil)
      super(message:)

      @user_message = user_message
    end

    private

    attr_reader :user_message

    memoize def corresponding_class
      PRESENTERS[user_message_class].new(user_message)
    end

    def user_message_class
      user_message.class.name.to_sym
    end
  end
end
