module Audio
  class VoiceCatalog
    DEFAULT_PROCESSOR = :elevenlabs_turbo_v2_5_audio
    DEFAULT_VOICE_SLUG = :adam

    class << self
      def slugs(processor: DEFAULT_PROCESSOR)
        voices_for(processor).keys
      end

      def voice_id(processor: DEFAULT_PROCESSOR, slug:)
        voices_for(processor).fetch(slug.to_sym).fetch(:voice_id)
      end

      def valid_slug?(processor: DEFAULT_PROCESSOR, slug:)
        voices_for(processor).key?(slug.to_sym)
      end

      private

      def voices_for(processor)
        AUDIO_VOICES.fetch(processor.to_sym)
      end
    end
  end
end
