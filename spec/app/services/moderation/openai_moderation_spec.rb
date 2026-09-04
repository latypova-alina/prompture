require "rails_helper"

describe Moderation::OpenaiModeration do
  describe ".flagged?" do
    subject { described_class.flagged?(text) }

    let(:text) { "test message" }

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
              input: text
            }
          )
          .and_return(response)
      end

      it { expect(subject).to eq(true) }
    end

    context "when scores trigger moderation" do
      let(:response) do
        {
          "results" => [
            {
              "categories" => {},
              "category_scores" => { "violence" => 0.71 }
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
              input: text
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
              input: text
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

      it "reports the failure to Sentry" do
        expect { subject }.to raise_error(ModerationRequestError)

        expect(Sentry).to have_received(:capture_exception).with(faraday_error)
      end
    end
  end
end
