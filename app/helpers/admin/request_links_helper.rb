module Admin
  # The one place that maps a (polymorphic) request to its admin show page. Anything that
  # isn't a command or button request (e.g. a message record) renders as plain "Class#id" text.
  module RequestLinksHelper
    def admin_request_link(record)
      admin_request_link_for(record.class.name, record.id)
    end

    def admin_request_link_for(class_name, id)
      label = Admin::RecordLabel.for(class_name, id)
      path = admin_request_path_for(class_name, id)
      path ? link_to(label, path) : label
    end

    private

    def admin_request_path_for(class_name, id)
      type = Admin::RequestSlug.for(class_name)
      return command_request_path(type:, id:) if command_request_class_names.include?(class_name)

      button_request_path(type:, id:) if button_request_class_names.include?(class_name)
    end

    def command_request_class_names
      Admin::CommandRequestsQuery::TYPES.map(&:name)
    end

    def button_request_class_names
      Admin::ButtonRequestTypes::ALL.map(&:name)
    end
  end
end
