module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module MultiSceneScript
        class FindScene
          include Interactor
          include Memery

          delegate :command_request, to: :context

          def call
            return context.fail!(error: CommandUnknownError) unless valid_scene_command?

            context.scene = scene

            return if scene.present?

            context.fail!(error: CommandUnknownError)
          end

          private

          def valid_scene_command?
            command_request.is_a?(CommandEditImageRequest) && command_request.cartoon_workflow?
          end

          delegate :image_prompt_id, to: :command_request

          memoize def scene
            Scene.find_by(image_prompt_id:)
          end
        end
      end
    end
  end
end
