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

          def prompt
            return request.audio_prompt.prompt if request.audio_prompt.present?

            super
          end

          def strategies
            STRATEGIES
          end
        end
      end
    end
  end
end
