module Generator
  module Video
    class SuccessNotifierJob
      include Sidekiq::Job

      def perform(video_url, chat_id)
        @video_url = video_url

        Telegram.bot.send_message(chat_id:, **reply_data)
      end

      private

      delegate :reply_data, to: :presenter
      attr_reader :video_url

      def presenter
        ::ButtonRequestPresenters::VideoProcessedMessagePresenter.new(video_url)
      end
    end
  end
end
