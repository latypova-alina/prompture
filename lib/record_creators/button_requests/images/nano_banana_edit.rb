module RecordCreators
  module ButtonRequests
    module Images
      class NanoBananaEdit < Base
        def record
          raise ImageNotReadyError unless image_url.present?

          super
        end

        private

        delegate :image_url, to: :image_resolver

        def processor
          "nano_banana_edit_image"
        end

        def image_resolver
          ButtonRequests::ImageResolver.new(parent_request)
        end
      end
    end
  end
end
