module MediaGenerator
  module ButtonHandler
    class CreateRequest
      include Interactor
      include Memery

      delegate :button_request, :parent_request, :command_request, to: :context

      HANDLERS = {
        "extend_prompt" => RecordCreators::ButtonRequests::ExtendPrompt,
        "flux_image" => RecordCreators::ButtonRequests::Images::Flux,
        "nano_banana_image" => RecordCreators::ButtonRequests::Images::NanoBanana,
        "nano_banana_edit_image" => RecordCreators::ButtonRequests::Images::NanoBananaEdit,
        "imagen_image" => RecordCreators::ButtonRequests::Images::Imagen,
        "kling_2_1_pro_image_to_video" => RecordCreators::ButtonRequests::Videos::Kling,
        "hailuo_02_standard_image_to_video" => RecordCreators::ButtonRequests::Videos::Hailuo02Standard,
        "veo3_1_lite_image_to_video" => RecordCreators::ButtonRequests::Videos::Veo31Lite
      }.freeze

      AUDIO_VOICE_HANDLER = RecordCreators::ButtonRequests::Audio::ElevenlabsTurbo

      def call
        context.button_request_record = record
      rescue ImageNotReadyError
        context.fail!(error: ImageNotReadyError)
      end

      private

      delegate :record, to: :record_creator

      def record_creator
        if audio_voice_slug?
          AUDIO_VOICE_HANDLER.new(parent_request, command_request, voice: button_request)
        else
          HANDLERS.fetch(button_request).new(parent_request, command_request)
        end
      end

      def audio_voice_slug?
        Audio::VoiceCatalog.valid_slug?(slug: button_request)
      end
    end
  end
end
