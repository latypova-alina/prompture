require "rails_helper"

describe Moderation::ResultRecorder do
  subject { described_class.call(input:, decision:, error:) }

  let(:command_request) { create(:command_prompt_to_image_request) }
  let(:input) { Moderation::Input.new(input_kind: "text", input_text: "a cat", command_request:) }
  let(:result) do
    { "flagged" => true, "categories" => { "violence" => true }, "category_scores" => { "violence" => 0.75 } }
  end
  let(:decision) { Moderation::Decision.new(Moderation::ResponseParser.new({ "results" => [result] })) }
  let(:error) { nil }

  it do
    is_expected.to have_attributes(
      command_request:, moderatable: nil, input_kind: "text", input_text: "a cat", model: "omni-moderation-latest",
      blocked: true, blocked_by: "violence_score", openai_flagged: true, result:, error: nil
    )
  end

  context "when the moderation call failed" do
    let(:decision) { nil }
    let(:error) { "the server responded with status 500" }

    it { is_expected.to have_attributes(blocked: false, blocked_by: nil, result: nil, error:) }
  end
end
