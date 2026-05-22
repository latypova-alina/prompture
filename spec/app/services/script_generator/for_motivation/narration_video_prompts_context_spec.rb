require "rails_helper"

describe ScriptGenerator::ForMotivation::NarrationVideoPromptsContext do
  subject(:context) { described_class.new(script:) }

  let(:script) { "You feel alone in the dark." }
  let(:connection) { instance_double(Faraday::Connection) }
  let(:response) { instance_double(Faraday::Response, success?: true, body:) }
  let(:body) { '["A crying person sitting alone in the rain", "Close-up of tears falling"]' }

  before do
    allow(ScriptGenerator::Connection).to receive(:call).and_return(connection)
    allow(connection).to receive(:post).and_return(response)
  end

  describe "#prompts" do
    it "returns parsed prompts from script generator API" do
      expect(context.prompts).to eq(
        ["A crying person sitting alone in the rain", "Close-up of tears falling"]
      )
    end

    it "posts script to narration video prompts endpoint" do
      request = instance_double(Faraday::Request, body: nil)
      allow(request).to receive(:body=)

      allow(connection).to receive(:post).with("/narration_video_prompts").and_yield(request).and_return(response)

      context.prompts

      expect(request).to have_received(:body=).with({ script: }.to_json)
    end

    context "when response is not successful" do
      let(:response) { instance_double(Faraday::Response, success?: false, body: "error") }

      it "raises ScriptGeneratorRequestError" do
        expect { context.prompts }.to raise_error(ScriptGeneratorRequestError)
      end
    end
  end
end
