module RecordCreators
  module ButtonRequests
    class ExtendPrompt < RecordCreators::Base
      def record
        ::ButtonExtendPromptRequest.create!(
          status: "PENDING",
          parent_request:
        )
      end
    end
  end
end
