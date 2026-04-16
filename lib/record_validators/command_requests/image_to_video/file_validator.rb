module RecordValidators
  module CommandRequests
    class ImageToVideo
      class FileValidator
        MAX_FILE_SIZE_BYTES = 10.megabytes

        def initialize(picture_id:, size_bytes:)
          @picture_id = picture_id
          @size_bytes = size_bytes
        end

        def valid?
          picture_id.present? && size_bytes_valid?
        end

        private

        attr_reader :picture_id, :size_bytes

        def size_bytes_valid?
          size_bytes.to_i <= MAX_FILE_SIZE_BYTES
        end
      end
    end
  end
end
