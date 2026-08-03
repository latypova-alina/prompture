class UserResolver
  include Memery

  def initialize(chat_id:, name:, locale:)
    @chat_id = chat_id
    @name = name
    @locale = locale
  end

  memoize def user
    User.find_or_create_by(chat_id:) do |u|
      u.name = name || "User#{chat_id}"
      u.locale = locale
    end
  end

  private

  attr_reader :chat_id, :name, :locale
end
