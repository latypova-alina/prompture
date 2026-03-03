module Generator
  module Video
    module RetrieveTask
      class ResponseParser
        include Memery

        def initialize(raw_body)
          @raw_body = raw_body
        end

        def video_url
          parsed_body.dig("data", "generated", 0)
        end

        private

        attr_reader :raw_body

        memoize def parsed_body
          JSON.parse(raw_body)
        end
      end
    end
  end
end
