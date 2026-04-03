module RecordValidators
  module UrlInspector
    class HeadRequester
      def initialize(uri:)
        @uri = uri
      end

      def run
        Requester.new(uri:, method: :head).run
      end

      private

      attr_reader :uri
    end
  end
end
