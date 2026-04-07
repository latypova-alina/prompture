module RecordValidators
  module CommandRequests
    class ImageToVideo
      class ImageUrlValidator
        include Memery

        def initialize(image_url:)
          @image_url = image_url
        end

        def valid?
          image_url_provided? && image_url_valid?
        end

        def invalid?
          image_url_provided? && !image_url_valid?
        end

        private

        attr_reader :image_url

        def image_url_provided?
          image_url.present?
        end

        memoize def image_url_valid?
          image_url_inspector.valid?
        end

        def image_url_inspector
          RecordValidators::UrlInspector::ImageUrlInspector.new(image_url:)
        end
      end
    end
  end
end
