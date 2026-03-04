module Generator
  module Media
    module RetrieveTask
      class TaskRetrieverBase
        def initialize(task_id, processor)
          @task_id = task_id
          @processor = processor
        end

        delegate :media_url, to: :extractor

        private

        attr_reader :task_id, :processor

        delegate :api_response, to: :api_client
        delegate :api_url, to: :api_url_fetcher

        def extractor
          extractor_class.new(api_response)
        end

        def api_client
          api_client_class.new(task_id, api_url)
        end

        def api_url_fetcher
          api_url_fetcher_class.new(processor)
        end

        def extractor_class
          raise NotImplementedError
        end

        def api_client_class
          raise NotImplementedError
        end

        def api_url_fetcher_class
          raise NotImplementedError
        end
      end
    end
  end
end
