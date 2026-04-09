module RecordValidators
  module CommandRequests
    class ImageToVideo
      PictureValidationContext = Struct.new(
        :picture_id,
        :width,
        :height,
        :size_bytes,
        keyword_init: true
      )
    end
  end
end
