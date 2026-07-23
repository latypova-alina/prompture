module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module ShortComplexScript
        class ResolveShort
          include Interactor
          include Memery

          delegate :parent_request, to: :context

          def call
            context.command_request = parent_request
            context.script = script
            context.scenes = scenes
          end

          private

          delegate :script, to: :scene, allow_nil: true
          delegate :scenes, to: :script, allow_nil: true

          delegate :image_prompt_id, to: :parent_request

          memoize def scene
            return if image_prompt_id.blank?

            Scene.find_by(image_prompt_id:)
          end
        end
      end
    end
  end
end
