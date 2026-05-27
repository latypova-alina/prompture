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

              raise ::Freepik::ResponseError if image_url.blank?

              image_url
            end

            private

            attr_reader :response

            memoize def parsed_body
              JSON.parse(response.body)
            end

            memoize def image_url
              parsed_body.dig("images", 0, "url")
            end
          end
        end
      end
    end
  end
end
