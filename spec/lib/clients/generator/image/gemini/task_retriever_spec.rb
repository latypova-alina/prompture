require "rails_helper"

describe Clients::Generator::Image::Gemini::TaskRetriever, :vcr do
  let(:task_id) { "14fc0c3d-4923-47bc-ae2c-b071542db9a2" }
  let(:task_retriever) { described_class.new(task_id) }

  describe "#status" do
    it "returns the status from the response" do
      VCR.use_cassette("gemini_task_retriever_success") do
        expect(task_retriever.status).to eq("COMPLETED")
      end
    end

    context "when response is not success" do
      it "raises a Freepik::ResponseError" do
        VCR.use_cassette("gemini_task_retriever_error") do
          expect { task_retriever.status }.to raise_error(::Freepik::ResponseError)
        end
      end
    end
  end

  describe "#image_url" do
    let(:image_url) do
      ["https://cdn-magnific.freepik.com/result_NANO_BANANA_14fc0c3d-4923-47bc-ae2c-b071542db9a2_0.png?token=exp=1760749154~hmac=69edca884ff7316584f76f40d729c4985f37921e92adc03b9497879913126a00&size=stable"]
    end

    it "returns the image URL from the response" do
      VCR.use_cassette("gemini_task_retriever_success") do
        expect(task_retriever.image_url).to eq(image_url)
      end
    end

    context "when response is not success" do
      it "raises a Freepik::ResponseError" do
        VCR.use_cassette("gemini_task_retriever_error") do
          expect { task_retriever.image_url }.to raise_error(::Freepik::ResponseError)
        end
      end
    end
  end
end
