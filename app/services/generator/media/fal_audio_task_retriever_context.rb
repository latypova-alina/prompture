module Generator
  module Media
    class FalAudioTaskRetrieverContext < FalTaskRetrieverContextBase
      private

      def media_urls
        url.present? ? [url] : []
      end

      def url
        payload.dig(:audio, :url)
      end
    end
  end
end
