module Admin
  class UserSearch
    def self.call(...)
      new(...).call
    end

    def initialize(query)
      @query = query
    end

    def call
      return User.none if query.blank?

      matches.reduce(:or)
    end

    private

    attr_reader :query

    def matches
      [name_match, id_match, chat_id_match].compact
    end

    def name_match
      User.where("name ILIKE ?", "%#{User.sanitize_sql_like(query)}%")
    end

    def id_match
      return unless numeric_query?

      User.where(id: query)
    end

    def chat_id_match
      return unless numeric_query?

      User.where(chat_id: query)
    end

    def numeric_query?
      query.match?(/\A\d+\z/)
    end
  end
end
