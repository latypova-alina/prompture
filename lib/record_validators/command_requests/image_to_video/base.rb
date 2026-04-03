module RecordValidators
  module CommandRequests
    class ImageToVideo
      class Base
        include Memery

        def initialize(picture_id:, image_url:)
          @picture_id = picture_id
          @image_url = image_url
        end

        def validate
          raise ImageUrlInvalid if image_url_invalid?
          raise MessageTypeError unless valid_message_type?
        end

        private

        attr_reader :picture_id, :image_url

        delegate :valid?, :invalid?, to: :image_url_validator, prefix: true
        delegate :valid?, to: :picture_validator, prefix: true

        def valid_message_type?
          image_url_valid? || picture_valid?
        end

        memoize def image_url_validator
          ImageUrlValidator.new(image_url:)
        end

        memoize def picture_validator
          PictureValidator.new(picture_id:)
        end
      end
    end
  end
end
