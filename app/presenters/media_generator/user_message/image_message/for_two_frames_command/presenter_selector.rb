module MediaGenerator
  module UserMessage
    module ImageMessage
      module ForTwoFramesCommand
        class PresenterSelector
          def initialize(request:)
            @request = request
          end

          def presenter
            assign_image_url

            return StartFramePresenter.new(locale:) if command_request.reload.awaiting_end_image?

            ReadyFramePresenter.new(locale:)
          end

          private

          attr_reader :request

          delegate :command_request, to: :request

          def assign_image_url
            MediaGenerator::FirstLastFrameToVideo::AssignImageUrl.call(image_record: request)
          end

          def locale
            command_request.user.locale
          end
        end
      end
    end
  end
end
