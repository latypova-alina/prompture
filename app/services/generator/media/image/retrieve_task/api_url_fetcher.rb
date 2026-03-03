module Generator
  module Media
    module Image
      module RetrieveTask
        class ApiUrlFetcher
          API_URLS = {
            "gemini_image" => "https://api.freepik.com/v1/ai/gemini-2-5-flash-image-preview".freeze,
            "mystic_image" => "https://api.freepik.com/v1/ai/mystic".freeze,
            "imagen_image" => "https://api.freepik.com/v1/ai/text-to-image/imagen3".freeze
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
