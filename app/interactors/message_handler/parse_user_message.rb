module MessageHandler
  class ParseUserMessage
    include Interactor
    include Memery

    delegate :user_message, to: :context

    def call
      context.message_text = message_text
      context.chat_id = chat_id
      context.picture_id = picture_id
    end

    private

    delegate :message_text, :picture_id, to: :message_parser

    memoize def message_parser
      MessageParser.new(user_message)
    end
  end
end
