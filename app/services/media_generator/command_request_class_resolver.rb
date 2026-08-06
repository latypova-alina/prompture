module MediaGenerator
  class CommandRequestClassResolver
    HANDLERS = {
      "prompt_to_image" => CommandPromptToImageRequest,
      "prompt_to_audio" => CommandPromptToAudioRequest,
      "prompt_to_video" => CommandPromptToVideoRequest,
      "image_to_video" => CommandImageToVideoRequest,
      "first_last_frame_to_video" => CommandTwoFrameToVideoRequest,
      "edit_image" => CommandEditImageRequest
    }.freeze

    def initialize(command:, user:)
      @command = command
      @user = user
    end

    def call
      return CommandPromptToVideoRequest if prompt_to_image_uses_video_workflow?

      HANDLERS[command]
    end

    private

    attr_reader :command, :user

    def prompt_to_image_uses_video_workflow?
      command == "prompt_to_image" && Flipper.enabled?(:prompt_to_image_video_workflow, user)
    end
  end
end
