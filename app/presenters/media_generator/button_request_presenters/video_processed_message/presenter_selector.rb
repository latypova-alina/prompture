module MediaGenerator
  module ButtonRequestPresenters
    module VideoProcessedMessage
      class PresenterSelector
        def initialize(context:)
          @context = context
        end

        attr_reader :context

        delegate :video_url, :command_request, :locale, :balance, :processor_name, :processor, to: :context

        def presenter
          presenter_class.new(
            message: video_url,
            locale:,
            balance:,
            processor_name:,
            processor:
          )
        end

        private

        def presenter_class
          if command_request.cartoon_script?
            ForCartoonScript
          else
            ::MediaGenerator::ButtonRequestPresenters::VideoProcessedMessagePresenter
          end
        end
      end
    end
  end
end
