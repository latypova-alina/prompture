class Moderation::OpenaiModeration
  def self.flagged?(text)
    response = OpenAIClient.moderations(
      parameters: {
        model: "omni-moderation-latest",
        input: text
      }
    )

    response.dig("results", 0, "flagged")
  end
end
