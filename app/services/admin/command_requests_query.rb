module Admin
  class CommandRequestsQuery
    TYPES = [
      CommandPromptToImageRequest,
      CommandPromptToVideoRequest,
      CommandImageToVideoRequest,
      CommandTwoFrameToVideoRequest,
      CommandEditImageRequest,
      CommandPromptToAudioRequest
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
      classes.flat_map { |klass| date_range.apply(klass.where(user:)).to_a }
             .sort_by(&:created_at)
             .reverse
    end

    def classes
      matched = TYPES.select { |klass| klass.name == type }
      matched.presence || TYPES
    end
  end
end
