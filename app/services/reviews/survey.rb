module Reviews
  # Versioned survey definitions. Changing questions means adding a new version (V2) and bumping
  # CURRENT_VERSION - stored reviews keep pointing at the version they were answered with.
  module Survey
    CURRENT_VERSION = 1
    VERSIONS = { 1 => Reviews::Survey::V1 }.freeze

    def self.questions(version = CURRENT_VERSION)
      VERSIONS.fetch(version)::QUESTIONS
    end

    def self.i18n_scope(version = CURRENT_VERSION)
      "reviews.survey.v#{version}"
    end
  end
end
