module Admin
  # A record's own columns as label => value, leaving out ids/polymorphic references
  # that the admin pages render as links instead.
  class RecordFields
    REFERENCE_COLUMNS = %w[
      id user_id parent_request_type parent_request_id command_request_type command_request_id
    ].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(record)
      @record = record
    end

    def call
      columns.index_with { |column| record.public_send(column) }
    end

    private

    attr_reader :record

    def columns
      record.class.column_names - REFERENCE_COLUMNS
    end
  end
end
