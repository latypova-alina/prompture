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
          presenter_class.new(
            request:,
            message:,
            balance:,
            locale: request.locale,
            processor_name:,
            processor:
          )
        end

        private

        attr_reader :request, :message, :balance, :processor_name, :processor

        def presenter_class
          return ForCartoonScript if cartoon_script_with_merge?

          DEFAULT_PRESENTER
        end

        def cartoon_script_with_merge?
          request.command_request.cartoon_script? &&
            request.audio_prompt.present? &&
            message.present? &&
            stored_video_url.present?
        end

        def stored_video_url
          video_request&.stored_video&.video_url
        end

        def video_request
          return unless request.parent_request.is_a?(ButtonVideoProcessingRequest)

          request.parent_request
        end
      end
    end
  end
end
