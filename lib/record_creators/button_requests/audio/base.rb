module RecordCreators
  module ButtonRequests
    module Audio
      class Base < RecordCreators::Base
        def record
          ::ButtonAudioProcessingRequest.create!(
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
