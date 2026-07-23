module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module Audio
        class FindScene
          include Interactor
          include Memery

          delegate :command_request, :parent_request, to: :context

          def call
            context.scene = scene
            context.video_prompt = origin_video_prompt

            return if command_request.cartoon_workflow? && scene.present?

            context.fail!(error: CommandUnknownError)
          end

          delegate :origin_video_prompt, to: :parent_request, allow_nil: true
          delegate :scene, to: :origin_video_prompt, allow_nil: true

          memoize :origin_video_prompt, :scene
        end
      end
    end
  end
end
