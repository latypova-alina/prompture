module Generator
  module Media
    class FalImageTaskRetrieverContext < FalTaskRetrieverContextBase
      private

      def media_urls
        payload.fetch(:images, []).filter_map { |image| image[:url] }
      end
    end
  end
end
