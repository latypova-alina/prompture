module Generator
  module Media
    module Audio
      module CreateTask
        class StrategySelector < Generator::Media::CreateTask::StrategySelectorBase
          STRATEGIES = {
            "elevenlabs_v3_audio" => ElevenlabsV3PayloadStrategy
          }.freeze

          def strategy
            strategies.fetch(processor).new(prompt, request.voice_id)
          end

          private

          def prompt
            return audio_prompt_text if audio_prompt_text.present?

            super
          end

          def strategies
            STRATEGIES
          end

          memoize def audio_prompt_text
            request.audio_prompt&.prompt
          end
        end
      end
    end
  end
end
