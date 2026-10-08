# Stubs the OpenAI moderations endpoint over HTTP. blocked: true returns a response our rules block
# (sexual/minors category); scores lets a spec set specific category scores.
module OpenaiModerationStub
  def stub_openai_moderation(blocked: false, scores: {}, flagged: blocked)
    result = {
      "flagged" => flagged,
      "categories" => { "sexual/minors" => blocked },
      "category_scores" => { "violence" => 0.01, "sexual" => 0.02 }.merge(scores),
      "category_applied_input_types" => { "violence" => ["text"] }
    }

    stub_request(:post, "https://api.openai.com/v1/moderations")
      .to_return(status: 200, body: { id: "modr-1", model: "omni-moderation-latest", results: [result] }.to_json,
                 headers: { "Content-Type" => "application/json" })
  end
end

RSpec.configure { |config| config.include OpenaiModerationStub }
