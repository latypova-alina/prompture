module Generator
  module Media
    class CancelUrlResolver
      BASE_URLS = {
        "flux_image" => "https://queue.fal.run/fal-ai/flux-2-pro",
        "nano_banana_image" => "https://queue.fal.run/fal-ai/nano-banana-2",
        "nano_banana_edit_image" => "https://queue.fal.run/fal-ai/nano-banana-2",
        "veo3_1_lite_image_to_video" => "https://queue.fal.run/fal-ai/veo3.1",
        "kling_2_1_pro_image_to_video" => "https://queue.fal.run/fal-ai/kling-video",
        "hailuo_02_standard_image_to_video" => "https://queue.fal.run/fal-ai/minimax"
      }.freeze

      def initialize(fal_request_id:, processor:)
        @fal_request_id = fal_request_id
        @processor = processor
      end

      def cancel_url
        "#{base_url}/requests/#{fal_request_id}/cancel"
      end

      def base_url
        BASE_URLS.fetch(processor)
      end

      private

      attr_reader :fal_request_id, :processor
    end
  end
end
