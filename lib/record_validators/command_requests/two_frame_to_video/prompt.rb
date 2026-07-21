module RecordValidators
  module CommandRequests
    module TwoFrameToVideo
      class Prompt
        def initialize(command_request:, message_text:, picture_id:)
          @command_request = command_request
          @message_text = message_text
          @picture_id = picture_id
        end

        def validate
          raise MessageTypeError unless valid_message_type?
          raise ImageNotReadyError unless frames_ready?
        end

        private

        attr_reader :command_request, :message_text, :picture_id

        def valid_message_type?
          prompt_message? && command_request.awaiting_video_prompt?
        end

        def frames_ready?
          command_request.frames_ready?
        end

        def prompt_message?
          message_text.present? && picture_id.blank?
        end
      end
    end
  end
end
