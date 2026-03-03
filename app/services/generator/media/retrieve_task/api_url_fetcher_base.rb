module Generator
  module Media
    module RetrieveTask
      class ApiUrlFetcherBase
        def initialize(processor)
          @processor = processor
        end

        def api_url
          api_urls[processor]
        end

        private

        attr_reader :processor

        def api_urls
          self.class::API_URLS
        end
      end
    end
  end
end
