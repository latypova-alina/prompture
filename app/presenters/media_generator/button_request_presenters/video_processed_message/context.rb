module MediaGenerator
  module ButtonRequestPresenters
    module VideoProcessedMessage
      Context = Struct.new(
        :video_url,
        :command_request,
        :locale,
        :balance,
        :processor_name,
        :processor,
        keyword_init: true
      )
    end
  end
end
