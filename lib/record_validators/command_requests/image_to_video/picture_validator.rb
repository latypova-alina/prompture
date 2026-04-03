module RecordValidators
  module CommandRequests
    class ImageToVideo
      class PictureValidator
        def initialize(picture_id:)
          @picture_id = picture_id
        end

        def valid?
          picture_id.present?
        end

        private

        attr_reader :picture_id
      end
    end
  end
end
