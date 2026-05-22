module ScriptGenerator
  module ForMotivation
    class ProcessMotivationWorkflow
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(chat_id:, language: "en")
        @chat_id = chat_id
        @language = language
      end

      def call
        audio_script_processor.call(script: script_text, voice: motivation_script_voice)
        ProcessScriptVideoPrompts.call(chat_id:, script: script_text)
      end

      private

      attr_reader :chat_id, :language

      delegate :script_text, to: :motivation_script_context

      memoize def motivation_script_context
        MotivationScriptContext.new(language:)
      end

      memoize def audio_script_processor
        ScriptGenerator::ProcessAudioScript.new(chat_id:)
      end

      memoize def motivation_script_voice
        MotivationScriptVoice.for(language:)
      end
    end
  end
end
