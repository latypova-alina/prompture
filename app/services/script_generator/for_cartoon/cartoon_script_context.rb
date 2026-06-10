module ScriptGenerator
  module ForCartoon
    class CartoonScriptContext
      include Memery

      def scenes
        CartoonScriptScenes.call(payload: cartoon_script_payload)
      end

      def reference_image_url
        CartoonScriptReferenceImageUrl.call(payload: cartoon_script_payload)
      end

      private

      memoize def cartoon_script_payload
        CartoonScriptPayload.call
      end
    end
  end
end
