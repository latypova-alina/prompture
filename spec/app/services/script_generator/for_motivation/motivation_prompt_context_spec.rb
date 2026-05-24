require "rails_helper"

describe ScriptGenerator::ForMotivation::MotivationPromptContext do
  subject(:context) { described_class.new(script:) }

  let(:script) { "You feel alone in the dark." }
  let(:connection) { instance_double(Faraday::Connection) }
  let(:response) { instance_double(Faraday::Response, success?: true, body:) }
  let(:body) do
    [
      { "subcategory" => "cry", "text" => "A crying person sitting alone in the rain" },
      { "subcategory" => "hope", "text" => "Close-up of tears falling" }
    ].to_json
  end

  before do
    allow(ScriptGenerator::Connection).to receive(:call).and_return(connection)
    allow(connection).to receive(:post).and_return(response)
  end

  describe "#scenes" do
    it "returns parsed scenes with subcategories" do
      scenes = context.scenes

      expect(scenes.size).to eq(2)
      expect(scenes.map(&:subcategory)).to eq(%w[cry hope])
      expect(scenes.map(&:prompt)).to eq(
        ["A crying person sitting alone in the rain", "Close-up of tears falling"]
      )
    end

    it "posts script to motivation prompt endpoint" do
      request = instance_double(Faraday::Request, body: nil)
      allow(request).to receive(:body=)

      allow(connection).to receive(:post).with("/motivation_prompt").and_yield(request).and_return(response)

      context.scenes

      expect(request).to have_received(:body=).with({ script: }.to_json)
    end

    context "when response is a string array" do
      let(:body) { '["A crying person sitting alone in the rain"]' }

      it "raises ScriptGeneratorRequestError" do
        expect { context.scenes }.to raise_error(ScriptGeneratorRequestError)
      end
    end

    context "when scene object is missing subcategory" do
      let(:body) do
        [{ "text" => "A crying person sitting alone in the rain" }].to_json
      end

      it "raises ScriptGeneratorRequestError" do
        expect { context.scenes }.to raise_error(ScriptGeneratorRequestError)
      end
    end

    context "when response is not successful" do
      let(:response) { instance_double(Faraday::Response, success?: false, body: "error") }

      it "raises ScriptGeneratorRequestError" do
        expect { context.scenes }.to raise_error(ScriptGeneratorRequestError)
      end
    end
  end
end
