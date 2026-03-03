module Generator
  module Media
    module Video
      module RetrieveTask
        class TaskRetriever < Generator::Media::RetrieveTask::TaskRetrieverBase
          private

          def extractor_class
            VideoExtractor
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
