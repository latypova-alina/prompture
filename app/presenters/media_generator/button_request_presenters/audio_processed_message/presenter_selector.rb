module MediaGenerator
  module ButtonRequestPresenters
    module AudioProcessedMessage
      class PresenterSelector
        DEFAULT_PRESENTER = ::MediaGenerator::ButtonRequestPresenters::AudioProcessedMessagePresenter

        def initialize(request:, message:, balance:, processor_name:, processor:)
          @request = request
          @message = message
          @balance = balance
          @processor_name = processor_name
          @processor = processor
        end

        def presenter
          return cartoon_presenter if cartoon_script_with_merge?

          default_presenter
        end

        def cartoon_presenter
          ForCartoonScript.new(
            request:,
            message:,
            balance:,
            locale: request.locale,
            processor_name:,
            processor:
          )
        end

        def default_presenter
          DEFAULT_PRESENTER.new(
            message:,
            balance:,
            locale: request.locale,
            processor_name:,
            processor:
          )
        end

        private

        attr_reader :request, :message, :balance, :processor_name, :processor

        def cartoon_script_with_merge?
          request.command_request.cartoon_workflow? &&
            request.audio_prompt.present? &&
            message.present? &&
            video_request&.persisted_video_url.present?
        end

        def video_request
          return unless request.parent_request.is_a?(ButtonVideoProcessingRequest)

          request.parent_request
        end
      end
    end
  end
end
