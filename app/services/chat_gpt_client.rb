class ChatGptClient
  include Memery

  API_URL = "https://api.openai.com/v1/chat/completions".freeze
  MODEL = "gpt-4o-mini".freeze

  def initialize(messages)
    @messages = messages
  end

  def response_body
    raise ChatGpt::NoResponseError unless response.success?

    body = JSON.parse(response.body)
    body.dig("choices", 0, "message", "content")
  end

  private

  attr_reader :messages

  def response
    connection.post do |req|
      req.body = {
        model: MODEL,
        messages:
      }.to_json
    end
  end

  memoize def connection
    Faraday.new(
      url: API_URL,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{ENV['OPENAI_API_KEY']}"
      }
    )
  end
end
