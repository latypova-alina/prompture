module Admin
  module ButtonRequestLabel
    def self.call(button_request)
      type = button_request.class.name.delete_prefix("Button").delete_suffix("Request").underscore.humanize
      "#{type} ##{button_request.id}"
    end
  end
end
