module MediaGenerator
  module UserMessage
    module ImageMessage
      class PresenterSelector
        include Memery

        def initialize(request:)
          @request = request
        end

        def presenter
          return EditImagePromptRequestPresenter.new if edit_image_command?
          return for_two_frames_presenter if two_frames_command?

          case request
          when UserImageUrlMessage
            ImageUrlMessagePresenter.new
          when UserPictureMessage
            PictureMessagePresenter.new
          else
            raise NotImplementedError, "Unsupported request type: #{request.class}"
          end
        end

        private

        attr_reader :request

        delegate :presenter, to: :for_two_frames, prefix: true

        memoize def for_two_frames
          ForTwoFramesCommand::PresenterSelector.new(request:)
        end

        def edit_image_command?
          request.command_request.is_a?(CommandEditImageRequest)
        end

        def two_frames_command?
          request.command_request.is_a?(CommandTwoFrameToVideoRequest)
        end
      end
    end
  end
end
