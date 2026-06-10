require "rails_helper"

describe ScriptGenerator::ForCartoon::CartoonScriptReferenceImageUrl do
  subject(:reference_image_url) { described_class.call(payload:) }

  let(:payload) do
    {
      "scenes" => ["Scene 1"],
      "reference_image_url" => "https://example.com/bloomy.png"
    }
  end

  it "returns reference_image_url from payload" do
    expect(reference_image_url).to eq("https://example.com/bloomy.png")
  end

  context "when reference_image_url is blank" do
    let(:payload) { { "reference_image_url" => "" } }

    it "raises ScriptGeneratorRequestError" do
      expect { reference_image_url }.to raise_error(ScriptGeneratorRequestError)
    end
  end
end
