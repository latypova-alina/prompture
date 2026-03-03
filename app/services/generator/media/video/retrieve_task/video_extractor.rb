module Generator
  module Media
    module Video
      module RetrieveTask
        class VideoExtractor
          include Memery

          def initialize(response)
            @response = response
          end

          def video_url
            raise Freepik::ResponseError unless response.success?

            parsed_body.dig("data", "generated", 0)
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
