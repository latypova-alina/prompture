module Admin
  module FieldsHelper
    def admin_field_value(value)
      return tag.span("—", class: "muted") if value.nil? || value == ""
      return link_to(value, value, target: "_blank", rel: "noopener") if url?(value)

      value.to_s
    end

    private

    def url?(value)
      value.is_a?(String) && value.start_with?("http://", "https://")
    end
  end
end
