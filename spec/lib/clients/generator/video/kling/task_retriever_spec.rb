require "rails_helper"

describe Clients::Generator::Video::Kling::TaskRetriever, :vcr do
  let(:task_id) { "192e8a86-eabf-40ce-b92a-33c6b7c2173d" }
  let(:task_retriever) { described_class.new(task_id) }

  describe "#status" do
    it "returns the status from the response" do
      VCR.use_cassette("kling_task_retriever_success") do
        expect(task_retriever.status).to eq("COMPLETED")
      end
    end

    context "when response is not success" do
      it "raises a Freepik::ResponseError" do
        VCR.use_cassette("kling_task_retriever_error") do
          expect { task_retriever.status }.to raise_error(::Freepik::ResponseError)
        end
      end
    end
  end

  describe "#video_url" do
    let(:video_url) do
      ["https://cdn-magnific.freepik.com/kling_192e8a86-eabf-40ce-b92a-33c6b7c2173d.mp4?token=exp=1761445403~hmac=4f4e13f2b5707fea609f1447da190ded4c539775255ddf40b880801413921f0c"]
    end

    it "returns the video URL from the response" do
      VCR.use_cassette("kling_task_retriever_success") do
        expect(task_retriever.video_url).to eq(video_url)
      end
    end

    context "when response is not success" do
      it "raises a Freepik::ResponseError" do
        VCR.use_cassette("kling_task_retriever_error") do
          expect { task_retriever.video_url }.to raise_error(::Freepik::ResponseError)
        end
      end
    end
  end
end
