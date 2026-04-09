module RecordValidators
  module CommandRequests
    class ImageToVideo
      class PictureValidator
        MAX_FILE_SIZE_BYTES = 10.megabytes
        MIN_RESOLUTION_PX = 300

        def initialize(context:)
          @context = context
        end

        def valid?
          picture_id.present? &&
            size_bytes_valid? &&
            resolution_valid?
        end

        private

        attr_reader :context

        delegate :picture_id, :width, :height, :size_bytes, to: :context

        def size_bytes_valid?
          size_bytes.to_i <= MAX_FILE_SIZE_BYTES
        end

        def resolution_valid?
          width.to_i >= MIN_RESOLUTION_PX && height.to_i >= MIN_RESOLUTION_PX
        end
      end
    end
  end
end
