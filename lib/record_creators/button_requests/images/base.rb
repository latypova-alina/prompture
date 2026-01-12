module RecordCreators
  module ButtonRequests
    module Images
      class Base < RecordCreators::Base
        def record
          ::ButtonImageProcessingRequest.create!(
            status: "PENDING",
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
