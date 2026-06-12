module ScriptGenerator
  module ForCartoon
    class SingleCartoonScriptContext
      include Memery

      def scenes
        CartoonScriptScenes.call(payload: single_cartoon_script_payload)
      end

      def reference_image_url
        CartoonScriptReferenceImageUrl.call(payload: single_cartoon_script_payload)
      end

      private

      memoize def single_cartoon_script_payload
        SingleCartoonScriptPayload.call
      end
    end
  end
end
