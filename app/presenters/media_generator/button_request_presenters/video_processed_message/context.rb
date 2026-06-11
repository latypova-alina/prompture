module MediaGenerator
  module ButtonRequestPresenters
    module VideoProcessedMessage
      class Context
        def initialize(video_url:, command_request:, locale:, balance:, processor_name:, processor:)
          @video_url = video_url
          @command_request = command_request
          @locale = locale
          @balance = balance
          @processor_name = processor_name
          @processor = processor
        end

        attr_reader :video_url, :command_request, :locale, :balance, :processor_name, :processor
      end
    end
  end
end
