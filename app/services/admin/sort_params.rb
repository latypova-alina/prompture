module Admin
  # Parses ?sort=&direction= against a table's whitelisted sort keys. Anything unknown falls
  # back to the default (newest first); a missing direction uses the key's natural first direction.
  class SortParams
    DIRECTIONS = %w[asc desc].freeze
    DEFAULT_KEY = "created".freeze
    DEFAULT = Admin::Sort.new(DEFAULT_KEY, "desc").freeze

    def self.call(...)
      new(...).call
    end

    def self.first_direction(key)
      key == DEFAULT_KEY ? "desc" : "asc"
    end

    def initialize(params, keys:)
      @params = params
      @keys = keys
    end

    def call
      return DEFAULT unless keys.include?(key)

      Admin::Sort.new(key, direction)
    end

    private

    attr_reader :params, :keys

    def key
      params[:sort].to_s
    end

    def direction
      DIRECTIONS.include?(params[:direction]) ? params[:direction] : self.class.first_direction(key)
    end
  end
end
