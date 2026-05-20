module Generator
  module Media
    module Audio
      module CreateTask
        class ElevenlabsTurboPayloadStrategy
          API_URL = "https://api.magnific.com/v1/ai/voiceover/elevenlabs-turbo-v2-5".freeze
          VOICE_ID = "IRHApOXLvnW57QJPQH2P".freeze

          def initialize(prompt)
            @prompt = prompt
          end

          def payload
            {
              text: prompt,
              voice_id: VOICE_ID
            }
          end

          def api_url
            API_URL
          end

          attr_reader :prompt
        end
      end
    end
  end
end
