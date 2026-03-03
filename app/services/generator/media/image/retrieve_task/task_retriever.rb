module Generator
  module Media
    module Image
      module RetrieveTask
        class TaskRetriever
          def initialize(task_id, processor)
            @task_id = task_id
            @processor = processor
          end

          delegate :image_url, to: :extractor

          private

          attr_reader :task_id, :processor

          delegate :api_response, to: :api_client
          delegate :api_url, to: :api_url_fetcher

          def extractor
            ImageExtractor.new(api_response)
          end

          def api_client
            ApiClient.new(task_id, api_url)
          end

          def api_url_fetcher
            ApiUrlFetcher.new(processor)
          end
        end
      end
    end
  end
end
