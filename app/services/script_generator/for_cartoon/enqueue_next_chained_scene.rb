module ScriptGenerator
  module ForCartoon
    class EnqueueNextChainedScene
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(image_url:, button_request:)
        @image_url = image_url
        @button_request = button_request
      end

      def call
        return if next_scene.blank?
        return if next_scene.image_prompt.blank?
        return if next_scene.image_prompt.stored_images.exists?

        ScriptGenerator::ProcessScript::ForEditImage.new(
          chat_id: command_request.chat_id,
          category: command_request.category,
          reference_image_url: image_url
        ).call(image_prompt_record: next_scene.image_prompt)
      end

      private

      attr_reader :image_url, :button_request

      delegate :command_request, to: :button_request

      memoize def scene
        return if command_request.image_prompt_id.blank?

        Scene.find_by(image_prompt_id: command_request.image_prompt_id)
      end

      memoize def script
        scene&.script
      end

      memoize def next_scene
        return if script.blank?
        return unless script.chained_references?

        script.scenes.find_by(order: scene.order + 1)
      end
    end
  end
end
