require "rails_helper"

describe Moderation::OpenaiModeration do
  describe ".flagged?" do
    subject { described_class.flagged?(text) }

    let(:text) { "test message" }

    context "when OpenAI marks content as flagged" do
      let(:response) do
        {
          "results" => [
            { "flagged" => true }
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

      it "returns true" do
        expect(subject).to eq(true)
      end
    end

    context "when OpenAI marks content as safe" do
      let(:response) do
        {
          "results" => [
            { "flagged" => false }
          ]
        }
      end

      before do
        allow(OpenAIClient)
          .to receive(:moderations)
          .and_return(response)
      end

      it "returns false" do
        expect(subject).to eq(false)
      end
    end
  end
end
