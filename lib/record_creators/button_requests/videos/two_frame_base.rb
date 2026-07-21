module RecordCreators
  module ButtonRequests
    module Videos
      class TwoFrameBase < RecordCreators::Base
        def record
          raise ImageNotReadyError unless frames_ready?

          ::ButtonVideoProcessingRequest.create!(
            image_url: command_request.start_image_url,
            status: "PENDING",
            parent_request:,
            processor:,
            command_request:
          )
        end

        private

        delegate :frames_ready?, to: :command_request

        def processor
          raise NotImplementedError
        end
      end
    end
  end
end
