module ButtonHandler
  class FindButtonParentMessage
    include Interactor
    include Memery

    delegate :tg_message_id, to: :context

    def call
      context.button_parent_message = button_parent_message
    end

    private

    memoize def button_parent_message
      ButtonParentMessage.find_by(tg_message_id:)
    end
  end
end
