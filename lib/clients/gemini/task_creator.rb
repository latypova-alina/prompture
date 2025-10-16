module Clients
  module Gemini
    class TaskCreator < BaseApiRequest
      include Memery

      VERTICAL_IMAGE_URL = "https://prompture.s3.eu-central-1.amazonaws.com/vertical.jpg".freeze

      def initialize(prompt)
        super()
        @prompt = prompt
      end

      def task_id
        response_body.dig("data", "task_id")
      end

      private

      attr_reader :prompt

      memoize def response
        connection.post { |req| req.body = payload.to_json }
      end

      def payload
        {
          prompt: prompt + "\nThe same ratio as reference image.",
          reference_images: [VERTICAL_IMAGE_URL]
        }
      end
    end
  end
end
