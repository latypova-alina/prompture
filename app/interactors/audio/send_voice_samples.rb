module Audio
  class SendVoiceSamples
    include Interactor
    include LocaleSupport
    include Memery

    GET_AUDIO_SAMPLES_CALLBACK = "get_audio_samples".freeze

    delegate :chat_id, to: :context

    def call
      with_locale(locale) do
        send_samples_message
      end
    end

    private

    def send_samples_message
      Telegram.bot.send_message(
        chat_id:,
        text: message_presenter.formatted_text,
        parse_mode: "HTML"
      )
    end

    delegate :locale, to: :user

    def message_presenter
      SampleMessagePresenter.new(locale:)
    end

    memoize def user
      User.find_by!(chat_id:)
    end
  end
end
