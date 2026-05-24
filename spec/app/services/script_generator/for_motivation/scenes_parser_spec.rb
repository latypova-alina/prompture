require "rails_helper"

describe ScriptGenerator::ForMotivation::ScenesParser do
  subject(:parsed_scenes) { described_class.new(parsed_response_body:).parsed_scenes }

  context "when value is a valid scene array" do
    let(:parsed_response_body) do
      [
        { "subcategory" => "cry", "text" => "A crying person sitting alone in the rain" },
        { "subcategory" => "Hope", "text" => "Person on a mountain at sunrise" }
      ]
    end

    it "returns video scenes with subcategories" do
      expect(parsed_scenes.size).to eq(2)
      expect(parsed_scenes.map(&:subcategory)).to eq(%w[cry Hope])
      expect(parsed_scenes.map(&:prompt)).to eq(
        ["A crying person sitting alone in the rain", "Person on a mountain at sunrise"]
      )
    end
  end

  context "when response is a string array" do
    let(:parsed_response_body) { ["A crying person sitting alone in the rain"] }

    it { is_expected.to be_nil }
  end

  context "when scene object is missing subcategory" do
    let(:parsed_response_body) { [{ "text" => "A crying person sitting alone in the rain" }] }

    it { is_expected.to be_nil }
  end
end
