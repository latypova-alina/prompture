module RecordValidators
  module UrlInspector
    class RangeRequester
      RANGE_HEADER = { "Range" => "bytes=0-0" }.freeze

      def initialize(uri:)
        @uri = uri
      end

      def run
        Requester.new(uri:, method: :get, headers: RANGE_HEADER).run
      end

      private

      attr_reader :uri
    end
  end
end
