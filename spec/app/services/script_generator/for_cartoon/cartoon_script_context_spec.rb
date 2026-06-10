require "rails_helper"

describe ScriptGenerator::ForCartoon::CartoonScriptContext do
  subject(:cartoon_script_context) { described_class.new }

  let(:payload) do
    {
      "scenes" => Array.new(12) { |index| "Scene #{index + 1}" },
      "reference_image_url" => "https://example.com/bloomy.png"
    }
  end

  before do
    allow(ScriptGenerator::ForCartoon::CartoonScriptPayload).to receive(:call).and_return(payload)
  end

  it "returns scenes from payload" do
    expect(cartoon_script_context.scenes).to eq(payload["scenes"])
  end

  it "returns reference_image_url from payload" do
    expect(cartoon_script_context.reference_image_url).to eq(payload["reference_image_url"])
  end

  it "fetches cartoon script payload once" do
    cartoon_script_context.scenes
    cartoon_script_context.reference_image_url

    expect(ScriptGenerator::ForCartoon::CartoonScriptPayload).to have_received(:call).once
  end
end
