require "rails_helper"

describe ScriptGenerator::ForMotivation::MotivationPromptContext do
  subject(:motivation_prompt_context) { described_class.new(chat_id:) }

  let(:chat_id) { 456 }
  let(:connection) { instance_double(Faraday::Connection) }
  let(:response) do
    instance_double(
      Faraday::Response,
      success?: true,
      body: '["Cinematic forest scene", "Rainy city rooftop"]',
      status: 200
    )
  end

  before do
    allow(ScriptGenerator::Connection).to receive(:call).and_return(connection)
    allow(connection).to receive(:get).with("/motivation_prompt").and_return(response)
  end

  describe "#prompts" do
    it "returns parsed prompts when request succeeds" do
      expect(motivation_prompt_context.prompts).to eq(["Cinematic forest scene", "Rainy city rooftop"])
    end

    context "when request fails with non-success status" do
      let(:response) { instance_double(Faraday::Response, success?: false, status: 500, body: "error") }

      it "raises ScriptGeneratorRequestError" do
        expect { motivation_prompt_context.prompts }.to raise_error(ScriptGeneratorRequestError)
      end
    end

    context "when response is not a JSON array" do
      let(:response) { instance_double(Faraday::Response, success?: true, body: '{"prompt":"one"}', status: 200) }

      it "raises ScriptGeneratorRequestError" do
        expect { motivation_prompt_context.prompts }.to raise_error(ScriptGeneratorRequestError)
      end
    end

    context "when Faraday raises an error" do
      before do
        allow(connection).to receive(:get).with("/motivation_prompt").and_raise(Faraday::TimeoutError.new("timeout"))
      end

      it "raises ScriptGeneratorRequestError" do
        expect { motivation_prompt_context.prompts }.to raise_error(ScriptGeneratorRequestError, "timeout")
      end
    end
  end
end
