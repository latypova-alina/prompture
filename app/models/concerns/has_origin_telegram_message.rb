module HasOriginTelegramMessage
  extend ActiveSupport::Concern

  def origin_telegram_message_id
    each_origin_parent_request do |req|
      message_id = telegram_message_id_for(req)
      return message_id if message_id.present?
    end

    nil
  end

  private

  def each_origin_parent_request
    req = parent_request_of(self)

    while req
      yield req

      req = parent_request_of(req)
    end
  end

  def parent_request_of(req)
    req.respond_to?(:parent_request) ? req.parent_request : nil
  end

  def telegram_message_id_for(req)
    return unless req.respond_to?(:bot_telegram_message)

    req.bot_telegram_message&.tg_message_id
  end
end
