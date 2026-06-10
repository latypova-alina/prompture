module ScriptGenerator
  module ProcessScript
    class ForEditImage < Base
      def initialize(chat_id:, category: nil, reference_image_url: nil)
        super(chat_id:, category:)
        @reference_image_url = reference_image_url
      end

      # Unlike ForVideo (memoized command_request on Base), each #call starts a separate
      # edit-image flow with its own CommandEditImageRequest.
      def call(image_prompt_record: nil)
        command_request = create_command_request!(image_prompt_record:)

        create_reference_image!(command_request:)

        StartEditImageGeneration.call(command_request:)
      end

      private

      attr_reader :reference_image_url

      def create_command_request!(image_prompt_record:)
        CommandEditImageRequest.create!(
          chat_id:,
          user:,
          category:,
          image_prompt: image_prompt_record
        )
      end

      def create_reference_image!(command_request:)
        UserImageUrlMessage.create!(
          image_url: reference_image_url,
          parent_request: command_request,
          command_request:
        )
      end
    end
  end
end
