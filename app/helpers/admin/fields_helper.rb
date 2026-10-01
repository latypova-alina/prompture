module Admin
  module FieldsHelper
    # Telegram file ids are long opaque strings - show a short prefix with a "more" toggle.
    TRUNCATED_FIELDS = %w[picture_id file_id].freeze
    TRUNCATE_LENGTH = 16
    # Telegram's photo dimensions for user pictures.
    PIXEL_FIELDS = %w[width height].freeze

    def admin_field_value(name, value)
      return tag.span("—", class: "muted") if value.nil? || value == ""
      return link_to("Open", value, target: "_blank", rel: "noopener") if url?(value)
      return truncated_value(value) if truncate?(name, value)
      return file_size(value) if name == "size"
      return "#{value} px" if PIXEL_FIELDS.include?(name)

      value.to_s
    end

    private

    def url?(value)
      value.is_a?(String) && value.start_with?("http://", "https://")
    end

    def truncate?(name, value)
      TRUNCATED_FIELDS.include?(name) && value.to_s.length > TRUNCATE_LENGTH
    end

    # Telegram's file_size for user pictures/files, stored in bytes.
    def file_size(bytes)
      "#{number_to_human_size(bytes)} (#{number_with_delimiter(bytes)} bytes)"
    end

    def truncated_value(value)
      tag.span(class: "truncated") do
        tag.span(truncate(value, length: TRUNCATE_LENGTH), class: "truncated-short") +
          tag.details(tag.summary("more") + tag.span(value, class: "truncated-full"))
      end
    end
  end
end
