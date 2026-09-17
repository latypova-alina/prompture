require "rails_helper"

describe Moderation::OpenaiImageModeration do
  describe ".flagged?" do
    subject { described_class.flagged?(bytes:, content_type:) }

    let(:bytes) { "image-bytes" }
    let(:content_type) { "image/jpeg" }
    let(:data_uri) { "data:image/jpeg;base64,#{Base64.strict_encode64(bytes)}" }

    context "when categories trigger moderation" do
      let(:response) do
        {
          "results" => [
            {
              "categories" => { "sexual/minors" => true },
              "category_scores" => {}
            }
          ]
        }
      end

      before do
        allow(OpenAIClient)
          .to receive(:moderations)
          .with(
            parameters: {
              model: "omni-moderation-latest",
              input: [{ type: "image_url", image_url: { url: data_uri } }]
            }
          )
          .and_return(response)
      end

      it { expect(subject).to eq(true) }
    end

    context "when categories and scores are safe" do
      let(:response) do
        {
          "results" => [
            {
              "categories" => { "sexual/minors" => false, "hate/threatening" => false },
              "category_scores" => {
                "violence" => 0.1,
                "violence/graphic" => 0.1,
                "sexual" => 0.1
              }
            }
          ]
        }
      end

      before do
        allow(OpenAIClient)
          .to receive(:moderations)
          .with(
            parameters: {
              model: "omni-moderation-latest",
              input: [{ type: "image_url", image_url: { url: data_uri } }]
            }
          )
          .and_return(response)
      end

      it { expect(subject).to eq(false) }
    end

    context "when the OpenAI request fails" do
      let(:faraday_error) { Faraday::TooManyRequestsError.new("the server responded with status 429") }

      before do
        allow(OpenAIClient).to receive(:moderations).and_raise(faraday_error)
        allow(Sentry).to receive(:capture_exception)
      end

      it "raises ModerationRequestError" do
        expect { subject }.to raise_error(ModerationRequestError, "the server responded with status 429")
      end
    end
  end
end
