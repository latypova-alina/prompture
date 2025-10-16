class ExtendPrompt
  include Interactor
  include Memery

  delegate :prompt, to: :context

  def call
    context.extended_prompt = response_body
  end

  private

  def messages
    [
      { "role" => "system", "content" => system_prompt },
      { "role" => "user", "content" => prompt }
    ]
  end

  def response_body
    chat_gpt_client.response_body
  end

  memoize def system_prompt
    File.read(Rails.root.join("config/prompts/prompt_generator_system_content.txt")).strip
  end

  memoize def chat_gpt_client
    Clients::ChatGpt::PromptGenerator.new(messages)
  end
end
