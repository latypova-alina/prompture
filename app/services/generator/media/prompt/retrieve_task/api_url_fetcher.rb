module Generator
  module Media
    module Prompt
      module RetrieveTask
        class ApiUrlFetcher < Generator::Media::RetrieveTask::ApiUrlFetcherBase
          API_URLS = {
            "extend_prompt" => "https://api.freepik.com/v1/ai/improve-prompt".freeze
          }.freeze
        end
      end
    end
  end
end
