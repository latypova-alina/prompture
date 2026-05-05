require "rails_helper"

describe ScriptGenerator::GenerateScript do
  subject(:result) { described_class.call }

  let(:connection) { instance_double(Faraday::Connection) }
  let(:response) { instance_double(Faraday::Response, success?: true, body: "script body", status: 200) }

  before do
    allow(Faraday).to receive(:new).and_return(connection)
    allow(connection).to receive(:get).with("/generate").and_return(response)
  end

  it "stores response body as script_array when request succeeds" do
    expect(result).to be_success
    expect(result.script_array).to eq("script body")
  end

  context "when request fails with non-success status" do
    let(:response) { instance_double(Faraday::Response, success?: false, body: "error", status: 500) }

    it "fails with ScriptGeneratorRequestError" do
      expect(result).to be_failure
      expect(result.error).to be_a(ScriptGeneratorRequestError)
    end
  end

  context "when Faraday raises an error" do
    before do
      allow(connection).to receive(:get).with("/generate").and_raise(Faraday::TimeoutError.new("timeout"))
    end

    it "fails with ScriptGeneratorRequestError" do
      expect(result).to be_failure
      expect(result.error).to be_a(ScriptGeneratorRequestError)
      expect(result.error.message).to include("timeout")
    end
  end
end
