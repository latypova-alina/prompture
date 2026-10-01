module Admin
  # Looks up the sort key class for a request class: what extra SQL to pluck next to id/created_at,
  # and how the plucked value becomes the ref's sort value.
  module RefSortKeys
    KEYS = {
      "created" => Admin::RefSortKeys::Created,
      "type" => Admin::RefSortKeys::Type,
      "kind" => Admin::RefSortKeys::Kind,
      "user" => Admin::RefSortKeys::User,
      "status" => Admin::RefSortKeys::Status,
      "category" => Admin::RefSortKeys::Category,
      "processor" => Admin::RefSortKeys::Processor,
      "cost" => Admin::RefSortKeys::Cost,
      "command" => Admin::RefSortKeys::Command
    }.freeze

    def self.for(key, klass)
      KEYS.fetch(key).new(klass)
    end
  end
end
