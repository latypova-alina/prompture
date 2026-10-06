module ChatEvents
  # Reads a Telegram update into chat_event attributes. Only an explicit allowlist of fields per
  # kind ends up in `payload` - never the raw update (no contact phone numbers, no coordinates...).
  class IncomingUpdate
    include Memery

    MESSAGE_TYPES = %w[photo document voice video audio video_note animation sticker contact location].freeze
    MEDIA_FIELDS = %w[file_id file_size width height duration mime_type file_name].freeze

    def initialize(update)
      @update = update.to_h.deep_stringify_keys
    end

    # nil when the update isn't tied to a chat we can attribute it to.
    def attributes
      return if chat_id.nil?

      {
        chat_id:, direction: "incoming", kind:, update_id: update["update_id"], occurred_at:,
        tg_message_id:, reply_to_message_id:, text:, payload:
      }
    end

    private

    attr_reader :update

    memoize def type
      (update.keys - ["update_id"]).first
    end

    memoize def body
      update.fetch(type, {})
    end

    memoize def message?
      %w[message edited_message].include?(type)
    end

    memoize def kind
      return "successful_payment" if message? && body["successful_payment"]

      type
    end

    memoize def chat_id
      body.dig("chat", "id") || body.dig("message", "chat", "id") || body.dig("from", "id")
    end

    def occurred_at
      timestamp = body["edit_date"] || body["date"]
      timestamp ? Time.zone.at(timestamp) : Time.current
    end

    def tg_message_id
      message? ? body["message_id"] : body.dig("message", "message_id")
    end

    def reply_to_message_id
      body.dig("reply_to_message", "message_id") if message?
    end

    def text
      body["text"] || body["caption"] if message?
    end

    def payload
      case kind
      when "message", "edited_message" then message_payload
      when "callback_query" then callback_payload
      when "pre_checkout_query" then payment_payload(body).merge("pre_checkout_query_id" => body["id"])
      when "successful_payment" then payment_payload(body["successful_payment"])
      else {}
      end
    end

    def message_payload
      media_type = MESSAGE_TYPES.find { |message_type| body.key?(message_type) }
      { "message_type" => media_type || "text", "media" => media(media_type) }.compact
    end

    # Photos come as several sizes; documents/voice/video as one object. Contacts and locations
    # are deliberately reduced to their type only.
    def media(media_type)
      return if media_type.nil? || %w[contact location].include?(media_type)

      Array.wrap(body[media_type]).map { |file| file.slice(*MEDIA_FIELDS) }
    end

    def callback_payload
      { "callback_query_id" => body["id"], "data" => body["data"] }
    end

    def payment_payload(payment)
      payment.slice("currency", "total_amount", "invoice_payload", "telegram_payment_charge_id")
    end
  end
end
