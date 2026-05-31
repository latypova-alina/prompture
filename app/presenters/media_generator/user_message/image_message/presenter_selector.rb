module MediaGenerator
  module UserMessage
    module ImageMessage
      class PresenterSelector
        def initialize(request:)
          @request = request
        end

        def presenter
          return EditImagePromptRequestPresenter.new if edit_image_command?

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

        def edit_image_command?
          request.command_request.is_a?(CommandEditImageRequest)
        end
      end
    end
  end
end
