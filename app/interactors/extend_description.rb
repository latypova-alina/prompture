class ExtendDescription
  include Interactor
  include Memery

  delegate :message, to: :context

  def call
    context.description = response_body
  end

  private

  def messages
    [
      { "role" => "system", "content" => system_prompt },
      { "role" => "user", "content" => message["text"] }
    ]
  end

  def response_body
    chat_gpt_client.response_body
  rescue ChatGpt::NoResponseError => e
    I18n.t("errors.chat_gpt.no_response")
  end

  memoize def system_prompt
    File.read(Rails.root.join("config/prompts/prompt_generator_system_content.txt")).strip
  end

  memoize def chat_gpt_client
    ChatGptClient.new(messages)
  end
end
