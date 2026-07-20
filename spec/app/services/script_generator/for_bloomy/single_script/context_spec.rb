require "rails_helper"

describe ScriptGenerator::ForBloomy::SingleScript::Context do
  subject(:context) { described_class.new }

  let(:payload) do
    {
      "scenes" => ["Scene 1"],
      "reference_image_url" => "https://example.com/bloomy.png"
    }
  end
  let(:single_cartoon_script_payload) do
    instance_double(ScriptGenerator::ForBloomy::Payloads::ForSingleCartoonScript, payload:)
  end

  before do
    allow(ScriptGenerator::ForBloomy::Payloads::ForSingleCartoonScript).to receive(:new)
      .and_return(single_cartoon_script_payload)
  end

  it "returns scenes from payload" do
    expect(context.scenes).to eq(payload["scenes"])
  end

  it "returns reference_image_url from payload" do
    expect(context.reference_image_url).to eq(payload["reference_image_url"])
  end

  it "fetches single cartoon script payload once" do
    context.scenes
    context.reference_image_url

    expect(ScriptGenerator::ForBloomy::Payloads::ForSingleCartoonScript).to have_received(:new).once
  end
end
