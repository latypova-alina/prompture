module Generator
  module Media
    module Image
      module RetrieveTask
        class TaskRetriever < Generator::Media::RetrieveTask::TaskRetrieverBase
          private

          def extractor_class
            Freepik::ImageExtractor
          end

          def api_client_class
            Freepik::ApiClient
          end

          def api_url_fetcher_class
            ApiUrlFetcher
          end
        end
      end
    end
  end
end
