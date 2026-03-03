module Generator
  module Media
    module Video
      module RetrieveTask
        class ApiUrlFetcher
          API_URLS = {
            "kling_2_1_pro_image_to_video" => "https://api.freepik.com/v1/ai/image-to-video/kling-v2-1".freeze
          }.freeze

          def initialize(processor)
            @processor = processor
          end

          def api_url
            API_URLS[processor]
          end

          private

          attr_reader :processor
        end
      end
    end
  end
end
