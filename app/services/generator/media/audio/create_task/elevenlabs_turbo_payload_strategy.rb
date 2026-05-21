module Generator
  module Media
    module Audio
      module CreateTask
        class ElevenlabsTurboPayloadStrategy
          API_URL = "https://api.magnific.com/v1/ai/voiceover/elevenlabs-turbo-v2-5".freeze

          def initialize(prompt, voice_id)
            @prompt = prompt
            @voice_id = voice_id
          end

          def payload
            {
              text: prompt,
              voice_id:
            }
          end

          def api_url
            API_URL
          end

          attr_reader :prompt, :voice_id
        end
      end
    end
  end
end
