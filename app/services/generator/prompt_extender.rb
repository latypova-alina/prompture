module Generator
  class PromptExtender
    include Memery

    def initialize(raw_prompt)
      @raw_prompt = raw_prompt
    end

    def extended_prompt
      chat_gpt_client.response_body
    end

    private

    attr_reader :raw_prompt

    def messages
      [
        { "role" => "system", "content" => system_prompt },
        { "role" => "user", "content" => raw_prompt }
      ]
    end

    memoize def system_prompt
      File.read(Rails.root.join("config/prompts/prompt_generator_system_content.txt")).strip
    end

    memoize def chat_gpt_client
      ::Clients::ChatGpt::ChatCompletionClient.new(messages)
    end
  end
end
