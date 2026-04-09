module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      ValidationContext = Struct.new(
        :picture_id,
        :image_url,
        :width,
        :height,
        :size_bytes,
        keyword_init: true
      )
    end
  end
end
