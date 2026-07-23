module ScriptGenerator
  module ForBloomy
    module MultiSceneScript
      class Context
        include Memery

        delegate :scenes, to: :cartoon_script_scenes_builder
        delegate :reference_image_url, to: :cartoon_script_reference_image_url_builder

        private

        delegate :payload, to: :multi_scene_script_payload

        memoize def multi_scene_script_payload
          Payloads::ForMultiSceneScript.new
        end

        memoize def cartoon_script_scenes_builder
          ScriptScenesBuilder.new(payload:)
        end

        memoize def cartoon_script_reference_image_url_builder
          ReferenceImageUrlBuilder.new(payload:)
        end
      end
    end
  end
end
