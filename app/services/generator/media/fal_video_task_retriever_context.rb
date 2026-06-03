module Generator
  module Media
    class FalVideoTaskRetrieverContext < FalTaskRetrieverContextBase
      private

      def media_urls
        url = payload.dig(:video, :url)

        url.present? ? [url] : []
      end
    end
  end
end
