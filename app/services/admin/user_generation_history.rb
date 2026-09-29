module Admin
  class UserGenerationHistory
    Entry = Struct.new(:command_request, :button_requests, keyword_init: true)

    COMMAND_ASSOCIATIONS = %i[
      command_prompt_to_image_requests
      command_prompt_to_video_requests
      command_image_to_video_requests
      command_two_frame_to_video_requests
      command_edit_image_requests
      command_prompt_to_audio_requests
    ].freeze

    BUTTON_REQUEST_CLASSES = [
      ButtonImageProcessingRequest,
      ButtonVideoProcessingRequest,
      ButtonAudioProcessingRequest,
      ButtonMergeAudioVideoProcessingRequest,
      ButtonExtendPromptRequest
    ].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(user:)
      @user = user
    end

    def call
      command_requests.map do |command_request|
        Entry.new(command_request:, button_requests: button_requests_for(command_request))
      end
    end

    private

    attr_reader :user

    def command_requests
      COMMAND_ASSOCIATIONS.flat_map { |association| user.public_send(association).to_a }
                          .sort_by(&:created_at)
                          .reverse
    end

    def button_requests_for(command_request)
      BUTTON_REQUEST_CLASSES.flat_map { |klass| klass.where(command_request:).to_a }
                            .sort_by(&:created_at)
    end
  end
end
