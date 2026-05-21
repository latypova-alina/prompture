module Audio
  class SampleMessagePresenter
    def initialize(locale:)
      @locale = locale
    end

    def formatted_text
      ([intro_line] + voice_lines).join("\n\n")
    end

    private

    attr_reader :locale

    def intro_line
      I18n.t("telegram_webhooks.message.audio_samples.intro", locale:)
    end

    def voice_lines
      VoiceSampleUrls.samples.map do |sample|
        I18n.t(
          "telegram_webhooks.message.audio_samples.voice_line",
          name: voice_name(sample[:slug]),
          url: sample[:url],
          link_label:,
          locale:
        )
      end
    end

    def voice_name(slug)
      I18n.t("telegram_webhooks.message.audio_samples.voices.#{slug}", locale:)
    end

    def link_label
      I18n.t("telegram_webhooks.message.audio_samples.listen", locale:)
    end
  end
end
