module MediaGenerator
  module UserMessage
    module ImageMessage
      class PresenterSelector
        def initialize(request:)
          @request = request
        end

        def presenter
          case request
          when ImageUrlMessage
            ImageUrlMessagePresenter.new(message: request.image_url)
          when PictureMessage
            PictureMessagePresenter.new
          else
            raise NotImplementedError, "Unsupported request type: #{request.class}"
          end
        end

        private

        attr_reader :request
      end
    end
  end
end
