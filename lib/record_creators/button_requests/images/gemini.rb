module RecordCreators
  module ButtonRequests
    module Images
      class Gemini < Base
        private

        def processor
          "gemini_image"
        end
      end
    end
  end
end
