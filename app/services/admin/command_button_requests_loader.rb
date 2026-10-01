module Admin
  # Loads button requests for an already-hydrated page of command requests: one query per
  # button table (matched on command_request_type/command_request_id, since the has_many
  # associations differ per command class), grouped by [command_request_type, command_request_id].
  class CommandButtonRequestsLoader
    def self.call(...)
      new(...).call
    end

    def initialize(command_requests)
      @command_requests = command_requests
    end

    def call
      return {} if command_requests.blank?

      button_requests.sort_by(&:created_at).group_by { |request| key_for(request) }
    end

    private

    attr_reader :command_requests

    def key_for(button_request)
      [button_request.command_request_type, button_request.command_request_id]
    end

    def button_requests
      Admin::ButtonRequestTypes::ALL.flat_map { |klass| matching(klass).to_a }
    end

    def matching(klass)
      ids_by_type.reduce(klass.none) do |relation, (command_type, ids)|
        relation.or(klass.where(command_request_type: command_type, command_request_id: ids))
      end
    end

    def ids_by_type
      command_requests.group_by { |record| record.class.name }.transform_values { |records| records.map(&:id) }
    end
  end
end
