require "rails_helper"

describe ScriptGenerator::ForCartoon::CartoonScriptScenes do
  subject(:scenes) { described_class.call(payload:) }

  let(:payload) do
    {
      "scenes" => Array.new(12) { |index| "Scene #{index + 1}" },
      "reference_image_url" => "https://example.com/bloomy.png"
    }
  end

  it "returns scenes from payload" do
    expect(scenes).to eq(payload["scenes"])
  end

  context "when scenes are blank" do
    let(:payload) { { "scenes" => [] } }

    it "raises ScriptGeneratorRequestError" do
      expect { scenes }.to raise_error(ScriptGeneratorRequestError)
    end
  end
end
