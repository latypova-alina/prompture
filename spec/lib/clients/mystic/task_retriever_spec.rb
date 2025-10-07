require "rails_helper"

describe Clients::Mystic::TaskRetriever, :vcr do
  let(:task_id) { "0a5f0976-011d-411e-abdf-8da8bd07ef9e" }
  let(:task_retriever) { described_class.new(task_id) }

  describe "#status" do
    it "returns the status from the response" do
      VCR.use_cassette("mystic_task_retriever_success") do
        expect(task_retriever.status).to eq("COMPLETED")
      end
    end
  end

  describe "#image_url" do
    let(:image_url) do
      ["https://ai-statics.freepik.com/content/mg-upscaler/uayccbiybndebh7v2izx6fy6oe/8c3bb0e2-a6c8-4eaf-9fd2-456b1fe5fe91_192d7016-d79f-4716-8870-40431cf00a98.png?token=exp=1759938722~hmac=8e074ea85722b1fec3e8f3c15c1a97b1"]
    end

    it "returns the image URL from the response" do
      VCR.use_cassette("mystic_task_retriever_success") do
        expect(task_retriever.image_url).to eq(image_url)
      end
    end
  end
end
