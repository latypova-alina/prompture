module Admin
  class ButtonRequestsQuery
    TYPES = [
      ButtonImageProcessingRequest,
      ButtonVideoProcessingRequest,
      ButtonAudioProcessingRequest,
      ButtonMergeAudioVideoProcessingRequest,
      ButtonExtendPromptRequest
    ].freeze

    MEDIA_ASSOCIATIONS = {
      ButtonImageProcessingRequest => :stored_image,
      ButtonVideoProcessingRequest => :stored_video,
      ButtonMergeAudioVideoProcessingRequest => :stored_video
    }.freeze

    def self.call(...)
      new(...).call
    end

    def self.count(...)
      new(...).count
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

    def count
      classes.sum { |klass| date_range.apply(scoped(klass)).count }
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
      relation = Admin::CommandRequestsQuery::TYPES.reduce(klass.none) do |rel, command_klass|
        rel.or(
          klass.where(command_request_type: command_klass.name,
                      command_request_id: command_klass.where(user:).select(:id))
        )
      end
      relation = relation.includes(command_request: :user)
      relation = relation.includes(MEDIA_ASSOCIATIONS[klass]) if MEDIA_ASSOCIATIONS[klass]
      relation
    end
  end
end
