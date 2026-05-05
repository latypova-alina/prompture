module ScriptGenerator
  class ProcessScript
    include Memery

    def initialize(chat_id:)
      @chat_id = chat_id
    end

    def call(script:)
      result = ScriptProcessor::ProcessScript.call(
        script:,
        command_request:,
        chat_id:
      )

      raise result.error if result.failure?
    end

    private

    attr_reader :chat_id

    memoize def command_request
      CommandPromptToImageRequest.create!(chat_id:, user:)
    end

    memoize def user
      User.find_by!(chat_id:)
    end
  end
end
