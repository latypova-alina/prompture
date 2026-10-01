module Admin
  # Button requests whose parent_request is the given button request, across all button tables, oldest first.
  class ButtonRequestChildren
    def self.call(...)
      new(...).call
    end

    def initialize(button_request)
      @button_request = button_request
    end

    def call
      Admin::ButtonRequestTypes::ALL.flat_map { |klass| matching(klass).to_a }.sort_by(&:created_at)
    end

    private

    attr_reader :button_request

    def matching(klass)
      klass.where(parent_request_type: button_request.class.name, parent_request_id: button_request.id)
    end
  end
end
