module MediaGenerator
  module ButtonHandler
    class CreateCartoonVideoRequest
      include Interactor
      include Memery

      PROCESSOR = "veo3_1_lite_image_to_video".freeze

      delegate :parent_request, :command_request, :script, to: :context

      def call
        context.button_request_record = button_video_processing_request
        context.button_request = PROCESSOR
      rescue ImageNotReadyError
        context.fail!(error: ImageNotReadyError)
      end

      private

      delegate :chat_id, :user, to: :command_request

      memoize def button_video_processing_request
        raise ImageNotReadyError unless image_url.present?

        ButtonVideoProcessingRequest.create!(
          image_url:,
          status: "PENDING",
          parent_request: prompt_message,
          processor: PROCESSOR,
          command_request: command_prompt_to_video_request
        )
      end

      memoize def prompt_message
        PromptMessage.create!(
          prompt: video_prompt_record.prompt,
          video_prompt: video_prompt_record,
          subcategory: cartoon_video_subcategory,
          parent_request:,
          command_request: command_prompt_to_video_request
        )
      end

      def cartoon_video_subcategory
        "video_prompt_#{video_prompt_record.id}"
      end

      memoize def command_prompt_to_video_request
        CommandPromptToVideoRequest.create!(
          chat_id:,
          user:,
          category: command_request.category
        )
      end

      memoize def video_prompt_record
        ScriptGenerator::ForCartoon::ProcessScriptVideoPrompt.call(script:)
      end

      memoize def image_url
        RecordCreators::ButtonRequests::ImageResolver.new(parent_request).image_url
      end
    end
  end
end
