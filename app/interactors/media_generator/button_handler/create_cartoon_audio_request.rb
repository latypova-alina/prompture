module MediaGenerator
  module ButtonHandler
    class CreateCartoonAudioRequest
      include Interactor
      include Memery

      PROCESSOR = "elevenlabs_v3_audio".freeze
      VOICE = "lulu_lollipop".freeze

      delegate :parent_request, :script, :video_prompt, to: :context

      def call
        context.audio_prompt_record = audio_prompt_record
        context.button_request_record = button_audio_processing_request
        context.button_request = PROCESSOR
      end

      private

      delegate :chat_id, :user, to: :command_request
      delegate :command_request, to: :parent_request

      memoize :command_request

      memoize def audio_prompt_record
        ScriptGenerator::ForCartoon::ProcessScriptAudioPrompt.call(
          script_text: script.script_text,
          video_prompt:
        )
      end

      memoize def button_audio_processing_request
        ButtonAudioProcessingRequest.create!(
          status: "PENDING",
          parent_request:,
          processor: PROCESSOR,
          voice: VOICE,
          audio_prompt: audio_prompt_record,
          command_request: command_prompt_to_audio_request
        )
      end

      memoize def command_prompt_to_audio_request
        CommandPromptToAudioRequest.create!(
          chat_id:,
          user:,
          category: command_request.category
        )
      end
    end
  end
end
