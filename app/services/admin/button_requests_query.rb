module Admin
  class ButtonRequestsQuery
    TYPES = [
      ButtonImageProcessingRequest,
      ButtonVideoProcessingRequest,
      ButtonAudioProcessingRequest,
      ButtonMergeAudioVideoProcessingRequest,
      ButtonExtendPromptRequest
    ].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(user:, type: nil, date_from: nil, date_to: nil, page: 1)
      @user = user
      @type = type
      @date_range = Admin::DateRangeFilter.new(date_from:, date_to:)
      @page = page
    end

    def call
      Admin::Page.call(records, page:)
    end

    private

    attr_reader :user, :type, :date_range, :page

    def records
      classes.flat_map { |klass| date_range.apply(scoped(klass)).to_a }
             .sort_by(&:created_at)
             .reverse
    end

    def classes
      matched = TYPES.select { |klass| klass.name == type }
      matched.presence || TYPES
    end

    def scoped(klass)
      Admin::CommandRequestsQuery::TYPES.reduce(klass.none) do |relation, command_klass|
        relation.or(
          klass.where(command_request_type: command_klass.name,
                      command_request_id: command_klass.where(user:).select(:id))
        )
      end
    end
  end
end
