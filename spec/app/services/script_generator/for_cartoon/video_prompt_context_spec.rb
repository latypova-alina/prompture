require "rails_helper"

describe ScriptGenerator::ForCartoon::VideoPromptContext do
  subject(:video_prompt_context) { described_class.new(script_text:) }

  let(:script_text) { "Bloomy waves hello in a sunny park." }
  let(:connection) { instance_double(Faraday::Connection) }
  let(:video_prompt) { "Camera slowly zooms in as Bloomy waves." }
  let(:response) do
    instance_double(
      Faraday::Response,
      success?: true,
      body: { "video_prompt" => video_prompt }
    )
  end

  before do
    allow(ScriptGenerator::Connection).to receive(:call).and_return(connection)
    allow(connection).to receive(:post).with("/generate_video_prompt").and_yield(
      instance_double(Faraday::Request, body: nil).tap do |request|
        allow(request).to receive(:body=)
      end
    ).and_return(response)
  end

  describe "#video_prompt" do
    it "returns video_prompt from response body" do
      expect(video_prompt_context.video_prompt).to eq(video_prompt)
    end

    it "posts script_text to the API" do
      request = instance_double(Faraday::Request)
      allow(request).to receive(:body=)
      allow(connection).to receive(:post).with("/generate_video_prompt").and_yield(request).and_return(response)

      video_prompt_context.video_prompt

      expect(request).to have_received(:body=).with({ script_text: }.to_json)
    end

    context "when request fails with non-success status" do
      let(:response) { instance_double(Faraday::Response, success?: false, body: "service unavailable") }

      it "raises ScriptGeneratorRequestError" do
        expect { video_prompt_context.video_prompt }.to raise_error(ScriptGeneratorRequestError)
      end
    end

    context "when video_prompt is blank" do
      let(:response) do
        instance_double(Faraday::Response, success?: true, body: { "video_prompt" => "" })
      end

      it "raises ScriptGeneratorRequestError" do
        expect { video_prompt_context.video_prompt }.to raise_error(ScriptGeneratorRequestError)
      end
    end

    context "when Faraday raises an error" do
      before do
        allow(connection).to receive(:post).with("/generate_video_prompt").and_raise(Faraday::TimeoutError.new("timeout"))
      end

      it "raises ScriptGeneratorRequestError" do
        expect { video_prompt_context.video_prompt }.to raise_error(ScriptGeneratorRequestError, "timeout")
      end
    end
  end
end
