module ButtonHandler
  module CreateRequest
    class KlingVideo
      include Interactor
      include Memery

      delegate :chat_id, :parent_request, :image_url, to: :context

      def call
        raise ImageForgottenError unless image_url.present?

        ::ButtonVideoProcessorRequest.create!(
          chat_id:,
          status: "PENDING",
          prompt:,
          image_url:,
          parent_request:,
          processor: "kling_2_1_pro_image_to_video"
        )
      end

      private

      delegate :prompt, to: :parent_request
    end
  end
end
