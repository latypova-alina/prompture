module Generator
  module Media
    class FalAudioTaskRetrieverContext < FalTaskRetrieverContextBase
      private

      def media_urls
        url = payload.dig(:audio, :url)

        url.present? ? [url] : []
      end
    end
  end
end
