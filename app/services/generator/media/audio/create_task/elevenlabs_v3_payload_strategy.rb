module Generator
  module Media
    module Audio
      module CreateTask
        class ElevenlabsV3PayloadStrategy
          API_URL = "https://queue.fal.run/fal-ai/elevenlabs/tts/eleven-v3".freeze

          def initialize(prompt, voice_id)
            @prompt = prompt
            @voice_id = voice_id
          end

          def payload
            {
              text: prompt,
              voice: voice_id
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
