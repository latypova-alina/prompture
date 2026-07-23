module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module ShortComplexScript
        class CreateVideoRequests
          include Interactor
          include Memery

          PROCESSOR = TotalCostCounter::PROCESSOR

          delegate :command_request, :scenes, to: :context
          delegate :user, to: :command_request

          def call
            return context.fail!(error: InsufficientCreditsError) unless enough_credits?

            create_and_enqueue_videos!
          rescue InsufficientCreditsError, ImageNotReadyError => e
            context.fail!(error: e.class)
          end

          private

          delegate :enough_credits?, to: :credits_validator
          delegate :scene_pairs, to: :scene_pairs_builder
          delegate :total_cost, to: :total_cost_counter

          def create_and_enqueue_videos!
            scene_pairs.each do |start_scene, end_scene|
              CreateAndEnqueue::Executor.call(
                start_scene:,
                end_scene:,
                command_request:
              )
            end
          end

          memoize def credits_validator
            CreditsValidator.new(user:, total_cost:)
          end

          memoize def total_cost_counter
            TotalCostCounter.new(scene_pairs:)
          end

          memoize def scene_pairs_builder
            ScenePairsBuilder.new(scenes:)
          end
        end
      end
    end
  end
end
