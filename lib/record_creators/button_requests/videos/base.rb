module RecordCreators
  module ButtonRequests
    module Videos
      class Base < RecordCreators::Base
        def record
          raise ImageForgottenError unless image_url.present?

          context.record = ::ButtonVideoProcessorRequest.create!(
            status: "PENDING",
            image_url:,
            parent_request:,
            processor:
          )
        end

        private

        def processor
          raise NotImplementedError
        end
      end
    end
  end
end
