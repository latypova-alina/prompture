module Generator
  module Media
    module Prompt
      module CreateTask
        class ExtendPromptPayloadStrategy
          API_URL = "https://api.freepik.com/v1/ai/improve-prompt".freeze
          TYPE = "image".freeze

          def initialize(prompt)
            @prompt = prompt
          end

          attr_reader :prompt

          def payload
            {
              prompt:,
              type: TYPE
            }
          end

          def api_url
            API_URL
          end
        end
      end
    end
  end
end
