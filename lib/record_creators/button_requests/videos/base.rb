module RecordCreators
  module ButtonRequests
    module Videos
      class Base < RecordCreators::Base
        def record
          raise ImageNotReadyError unless image_url.present?

          ::ButtonVideoProcessingRequest.create!(
            image_url:,
            status: "PENDING",
            parent_request:,
            processor:,
            command_request:
          )
        end

        private

        delegate :image_url, to: :image_resolver

        def image_resolver
          ImageResolver.new(parent_request)
        end

        def processor
          raise NotImplementedError
        end
      end
    end
  end
end
