module MessageAccessor
  extend ActiveSupport::Concern
  include Memery

  private

  memoize def message_parser
    MessageParser.new(user_message)
  end
end
