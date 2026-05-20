module Generator
  module Media
    module Audio
      module RetrieveTask
        class ApiUrlFetcher
          URLS = {
            "elevenlabs_turbo_v2_5_audio" => "https://api.magnific.com/v1/ai/voiceover/elevenlabs-turbo-v2-5".freeze
          }.freeze

          def initialize(processor)
            @processor = processor
          end

          def api_url
            URLS.fetch(processor)
          end

          private

          attr_reader :processor
        end
      end
    end
  end
end
