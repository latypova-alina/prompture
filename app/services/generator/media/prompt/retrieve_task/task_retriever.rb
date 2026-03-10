module Generator
  module Media
    module Prompt
      module RetrieveTask
        class TaskRetriever < Generator::Media::RetrieveTask::TaskRetrieverBase
          private

          def extractor_class
            PromptExtractor
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
