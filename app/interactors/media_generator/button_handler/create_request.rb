module MediaGenerator
  module ButtonHandler
    class CreateRequest
      include Interactor
      include Memery

      delegate :button_request, :parent_request, :command_request, to: :context

      HANDLERS = {
        "extend_prompt" => RecordCreators::ButtonRequests::ExtendPrompt,
        "mystic_image" => RecordCreators::ButtonRequests::Images::Mystic,
        "flux_image" => RecordCreators::ButtonRequests::Images::Flux,
        "gemini_image" => RecordCreators::ButtonRequests::Images::Gemini,
        "imagen_image" => RecordCreators::ButtonRequests::Images::Imagen,
        "kling_2_1_pro_image_to_video" => RecordCreators::ButtonRequests::Videos::Kling,
        "seedance_1_5_pro_image_to_video" => RecordCreators::ButtonRequests::Videos::Seedance,
        "wan_2_2_image_to_video" => RecordCreators::ButtonRequests::Videos::Wan
      }.freeze

      def call
        context.button_request_record = record
      rescue ImageNotReadyError
        context.fail!(error: ImageNotReadyError)
      end

      private

      delegate :record, to: :record_creator

      def record_creator
        HANDLERS[button_request].new(parent_request, command_request)
      end
    end
  end
end
