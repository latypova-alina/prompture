module Generator
  module Media
    module Image
      module RetrieveTask
        module Flux
          class ImageExtractor
            include Memery

            def initialize(response)
              @response = response
            end

            def media_url
              raise ::Freepik::ResponseError unless response.success?
              raise ::Freepik::ResponseError unless parsed_body["code"] == 200
              raise ::Freepik::ResponseError unless parsed_body.dig("data", "successFlag") == 1

              parsed_body.dig("data", "response", "resultImageUrl")
            end

            private

            attr_reader :response

            memoize def parsed_body
              JSON.parse(response.body)
            end
          end
        end
      end
    end
  end
end
