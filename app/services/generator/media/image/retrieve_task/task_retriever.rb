module Generator
  module Media
    module Image
      module RetrieveTask
        class TaskRetriever < Generator::Media::RetrieveTask::TaskRetrieverBase
          PROCESSOR_API_CLIENTS = {
            "flux_image" => Flux::ApiClient
          }.freeze

          PROCESSOR_EXTRACTORS = {
            "flux_image" => Flux::ImageExtractor
          }.freeze

          private

          def extractor_class
            PROCESSOR_EXTRACTORS.fetch(processor, Freepik::ImageExtractor)
          end

          def api_client_class
            PROCESSOR_API_CLIENTS.fetch(processor, Freepik::ApiClient)
          end

          def api_url_fetcher_class
            ApiUrlFetcher
          end
        end
      end
    end
  end
end
