module MediaGenerator
  module ButtonRequestPresenters
    module ImageProcessedMessage
      Context = Struct.new(
        :image_url,
        :command_request_classname,
        :command_request_category,
        :locale,
        :balance,
        :processor_name,
        :processor,
        keyword_init: true
      )
    end
  end
end
