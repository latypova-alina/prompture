module ChatEvents
  # The allowlisted part of an outgoing call worth keeping: formatting, buttons, media, all ids of a
  # media group, and the error if the call failed.
  class OutgoingPayload
    BODY_FIELDS = %w[parse_mode reply_markup photo video audio voice document animation show_alert url
                     title description payload currency prices].freeze

    def initialize(body:, message_ids:, error:)
      @body = body
      @message_ids = message_ids
      @error = error
    end

    def to_h
      body_fields.merge(media_group, message_ids_field, error_field)
    end

    private

    attr_reader :body, :message_ids, :error

    def body_fields
      body.slice(*BODY_FIELDS).transform_values { |value| serializable(value) }
    end

    # Uploaded files (IO) can't be stored - just note that something was uploaded.
    def serializable(value)
      value.respond_to?(:read) ? "(upload)" : value
    end

    def media_group
      return {} unless body["media"].is_a?(Array)

      { "media" => body["media"].map { |item| item.to_h.stringify_keys.slice("type", "media", "caption") } }
    end

    def message_ids_field
      message_ids.size > 1 ? { "message_ids" => message_ids } : {}
    end

    def error_field
      error ? { "error" => { "class" => error.class.name, "message" => error.message } } : {}
    end
  end
end
