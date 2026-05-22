module ScriptGenerator
  module ForMotivation
    class MotivationScriptVoice
      VOICES_BY_LANGUAGE = {
        "en" => "adam",
        "pl" => "adam",
        "ru" => "knox_dark"
      }.freeze

      DEFAULT_LANGUAGE = "en"

      class << self
        def for(language:)
          VOICES_BY_LANGUAGE.fetch(normalize(language))
        end

        private

        def normalize(language)
          language.to_s.presence || DEFAULT_LANGUAGE
        end
      end
    end
  end
end
