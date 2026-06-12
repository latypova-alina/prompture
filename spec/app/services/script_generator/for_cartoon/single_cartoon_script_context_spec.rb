require "rails_helper"

describe ScriptGenerator::ForCartoon::SingleCartoonScriptContext do
  subject(:single_cartoon_script_context) { described_class.new }

  let(:payload) do
    {
      "scenes" => ["Scene 1"],
      "reference_image_url" => "https://example.com/bloomy.png"
    }
  end

  before do
    allow(ScriptGenerator::ForCartoon::SingleCartoonScriptPayload).to receive(:call).and_return(payload)
  end

  it "returns scenes from payload" do
    expect(single_cartoon_script_context.scenes).to eq(payload["scenes"])
  end

  it "returns reference_image_url from payload" do
    expect(single_cartoon_script_context.reference_image_url).to eq(payload["reference_image_url"])
  end

  it "fetches single cartoon script payload once" do
    single_cartoon_script_context.scenes
    single_cartoon_script_context.reference_image_url

    expect(ScriptGenerator::ForCartoon::SingleCartoonScriptPayload).to have_received(:call).once
  end
end
