require "rails_helper"

describe ScriptGenerator::ScriptContext do
  subject(:script_context) { described_class.new(chat_id:, template_name:) }

  let(:chat_id) { 456 }
  let(:template_name) { nil }
  let(:connection) { instance_double(Faraday::Connection) }
  let(:response) { instance_double(Faraday::Response, success?: true, body: "scene one\n\nscene two", status: 200) }

  before do
    allow(ScriptGenerator::Connection).to receive(:call).and_return(connection)
    allow(connection).to receive(:get).with("/generate", { template_name: }).and_return(response)
  end

  describe "#script_array" do
    it "returns response body when request succeeds" do
      expect(script_context.script_array).to eq("scene one\n\nscene two")
    end

    context "when request fails with non-success status" do
      let(:response) { instance_double(Faraday::Response, success?: false, status: 500, body: "template not found") }

      it "raises result error" do
        expect { script_context.script_array }.to raise_error(ScriptGeneratorRequestError)
      end
    end

    context "when Faraday raises an error" do
      before do
        allow(connection).to receive(:get).with("/generate", { template_name: })
                                          .and_raise(Faraday::TimeoutError.new("timeout"))
      end

      it "raises ScriptGeneratorRequestError" do
        expect { script_context.script_array }
          .to raise_error(ScriptGeneratorRequestError, "timeout")
      end
    end

    context "when template_name is present" do
      let(:template_name) { "daily_news" }

      it "passes template_name in request params" do
        script_context.script_array

        expect(connection).to have_received(:get).with("/generate", { template_name: "daily_news" })
      end
    end
  end
end
