module ButtonHandler
  class CreateRequest
    include Interactor
    include Memery

    delegate :button_request, :chat_id, :parent_request, :image_url, to: :context

    HANDLERS = {
      "extend_prompt" => CreateRequest::ExtendPrompt,
      "mystic_image" => CreateRequest::MysticImage,
      "gemini_image" => CreateRequest::GeminiImage,
      "imagen_image" => CreateRequest::ImagenImage,
      "kling_2_1_pro_image_to_video" => CreateRequest::KlingVideo
    }.freeze

    def call
      HANDLERS[button_request].call(chat_id:, parent_request:, image_url:)
    end
  end
end
