module ScriptGenerator
  class ProcessScript
    include Memery

    def initialize(chat_id:, category: nil)
      @chat_id = chat_id
      @category = category
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

    attr_reader :chat_id, :category

    memoize def command_request
      CommandPromptToVideoRequest.create!(chat_id:, user:, category:)
    end

    memoize def user
      User.find_by!(chat_id:)
    end
  end
end
