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

        delegate :awaiting_video_prompt?, :frames_ready?, to: :command_request

        def valid_message_type?
          prompt_message? && awaiting_video_prompt?
        end

        def prompt_message?
          message_text.present? && picture_id.blank?
        end
      end
    end
  end
end
