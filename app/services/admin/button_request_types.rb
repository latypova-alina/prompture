module Admin
  module ButtonRequestTypes
    ALL = [
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

    # The DB default is lowercase "pending", but application code (success/failure
    # notifiers) writes these uppercase values - Admin::ButtonRequestScope matches
    # case-insensitively so rows still on the DB default aren't silently excluded.
    STATUSES = %w[PENDING COMPLETED FAILED CANCELLED].freeze

    def self.processor_options
      ALL.select { |klass| klass.column_names.include?("processor") }
         .flat_map { |klass| klass::PROCESSOR_TYPES }
         .uniq
    end

    def self.media_association_for(klass)
      MEDIA_ASSOCIATIONS[klass]
    end
  end
end
