module ScriptGenerator
  module ForCartoon
    class CartoonProblemSolutionScriptContext
      include Memery

      def scenes
        CartoonScriptScenes.call(payload: cartoon_problem_solution_script_payload)
      end

      def reference_image_url
        CartoonScriptReferenceImageUrl.call(payload: cartoon_problem_solution_script_payload)
      end

      private

      memoize def cartoon_problem_solution_script_payload
        CartoonProblemSolutionScriptPayload.call
      end
    end
  end
end
