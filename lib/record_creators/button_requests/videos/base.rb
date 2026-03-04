module RecordCreators
  module ButtonRequests
    module Videos
      class Base < RecordCreators::Base
        def record
          raise ImageForgottenError unless image_url.present?

          ::ButtonVideoProcessingRequest.create!(
            image_url:,
            status: "PENDING",
            parent_request:,
            processor:,
            command_request:
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
