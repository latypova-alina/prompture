module Generator
  module Media
    module Audio
      module CreateTask
        class StrategySelector < Generator::Media::CreateTask::StrategySelectorBase
          STRATEGIES = {
            "elevenlabs_turbo_v2_5_audio" => ElevenlabsTurboPayloadStrategy
          }.freeze

          def strategy
            strategies.fetch(processor).new(prompt, request.voice_id)
          end

          def strategies
            STRATEGIES
          end
        end
      end
    end
  end
end
