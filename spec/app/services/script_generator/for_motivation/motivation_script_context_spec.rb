require "rails_helper"

describe ScriptGenerator::ForMotivation::MotivationScriptContext do
  subject(:motivation_script_context) { described_class.new(chat_id:, language:) }

  let(:chat_id) { 456 }
  let(:language) { "en" }
  let(:connection) { instance_double(Faraday::Connection) }
  let(:response) do
    instance_double(
      Faraday::Response,
      success?: true,
      body: { script: "Here's the brutal truth.\n\nNobody will save you." }.to_json,
      status: 200
    )
  end

  before do
    allow(ScriptGenerator::Connection).to receive(:call).and_return(connection)
    allow(connection).to receive(:get).with("/motivation_script", { language: }).and_return(response)
  end

  describe "#script_text" do
    it "returns script text when request succeeds" do
      expect(motivation_script_context.script_text).to eq("Here's the brutal truth.\n\nNobody will save you.")
    end

    context "when language is passed" do
      let(:language) { "pl" }

      it "passes language in request params" do
        motivation_script_context.script_text

        expect(connection).to have_received(:get).with("/motivation_script", { language: "pl" })
      end
    end

    context "when request fails with non-success status" do
      let(:response) { instance_double(Faraday::Response, success?: false, status: 500, body: "error") }

      it "raises ScriptGeneratorRequestError" do
        expect { motivation_script_context.script_text }.to raise_error(ScriptGeneratorRequestError)
      end
    end

    context "when script is blank" do
      let(:response) do
        instance_double(Faraday::Response, success?: true, body: { script: "  " }.to_json, status: 200)
      end

      it "raises ScriptGeneratorRequestError" do
        expect { motivation_script_context.script_text }.to raise_error(ScriptGeneratorRequestError)
      end
    end
  end
end
