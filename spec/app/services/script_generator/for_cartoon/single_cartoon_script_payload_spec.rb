require "rails_helper"

describe ScriptGenerator::ForCartoon::SingleCartoonScriptPayload do
  subject(:single_cartoon_script_payload) { described_class.call }

  let(:connection) { instance_double(Faraday::Connection) }
  let(:body) do
    {
      "scenes" => ["Scene 1"],
      "reference_image_url" => "https://example.com/bloomy.png"
    }
  end
  let(:response) do
    instance_double(Faraday::Response, success?: true, body:)
  end

  before do
    allow(ScriptGenerator::Connection).to receive(:call).and_return(connection)
    allow(connection).to receive(:get).with("/single_cartoon_script").and_return(response)
  end

  it "returns parsed response body" do
    expect(single_cartoon_script_payload).to eq(body)
  end

  context "when request fails with non-success status" do
    let(:response) { instance_double(Faraday::Response, success?: false, body: "service unavailable") }

    it "raises ScriptGeneratorRequestError" do
      expect { single_cartoon_script_payload }.to raise_error(ScriptGeneratorRequestError)
    end
  end

  context "when Faraday raises an error" do
    before do
      allow(connection).to receive(:get)
        .with("/single_cartoon_script")
        .and_raise(Faraday::TimeoutError.new("timeout"))
    end

    it "raises ScriptGeneratorRequestError" do
      expect { single_cartoon_script_payload }.to raise_error(ScriptGeneratorRequestError, "timeout")
    end
  end
end
