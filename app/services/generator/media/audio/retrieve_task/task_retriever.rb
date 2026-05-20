module Generator
  module Media
    module Audio
      module RetrieveTask
        class TaskRetriever < Generator::Media::RetrieveTask::TaskRetrieverBase
          private

          def extractor_class
            AudioExtractor
          end

          def api_client_class
            ApiClient
          end

          def api_url_fetcher_class
            ApiUrlFetcher
          end
        end
      end
    end
  end
end
