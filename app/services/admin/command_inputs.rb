module Admin
  # What the user sent for a command (prompts, pictures, image URLs, files), oldest first.
  class CommandInputs
    MESSAGE_TYPES = [PromptMessage, UserPictureMessage, UserImageUrlMessage, UserFileMessage].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(command_request)
      @command_request = command_request
    end

    def call
      MESSAGE_TYPES.flat_map { |klass| matching(klass).to_a }.sort_by(&:created_at)
    end

    private

    attr_reader :command_request

    def matching(klass)
      relation = klass.where(command_request_type: command_request.class.name, command_request_id: command_request.id)
      Admin::InputMedia::IMAGE_MESSAGE_TYPES.include?(klass) ? relation.includes(:stored_image) : relation
    end
  end
end
