module ScriptGenerator
  module ForCartoon
    module ShortComplexScript
      class Context
        include Memery

        delegate :scenes, to: :cartoon_script_scenes_builder
        delegate :reference_image_url, to: :cartoon_script_reference_image_url_builder

        private

        delegate :payload, to: :cartoon_problem_solution_script_payload

        memoize def cartoon_problem_solution_script_payload
          Payloads::ForCartoonProblemSolutionScript.new
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
