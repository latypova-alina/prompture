require "rails_helper"

describe Generator::Media::Prompt::RetrieveTask::PromptExtractor do
  subject(:media_url) { described_class.new(response).media_url }

  let(:response) { instance_double("Response", success?: success, body: body) }
  let(:success) { true }
  let(:body) { { data: { generated: ["extended prompt text"] } }.to_json }

  describe "#media_url" do
    context "when response is successful" do
      it "returns extracted text from response" do
        expect(media_url).to eq("extended prompt text")
      end
    end

    context "when response is not successful" do
      let(:success) { false }

      it "raises Freepik::ResponseError" do
        expect { media_url }.to raise_error(Freepik::ResponseError)
      end
    end
  end
end
