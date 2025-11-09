module Generator
  module Image
    class SuccessNotifierJob
      include Sidekiq::Job

      def perform(image_url, chat_id)
        @image_url = image_url

        Telegram.bot.send_message(chat_id:, **reply_data)
      end

      private

      delegate :reply_data, to: :presenter
      attr_reader :image_url

      def presenter
        ButtonMessagePresenter.new(image_url, "image_message")
      end
    end
  end
end
