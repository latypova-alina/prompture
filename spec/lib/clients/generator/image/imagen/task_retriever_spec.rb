require "rails_helper"

describe Clients::Generator::Image::Imagen::TaskRetriever, :vcr do
  let(:task_id) { "a35022aa-611a-40a1-a792-4562a4058aab" }
  let(:task_retriever) { described_class.new(task_id) }

  describe "#status" do
    it "returns the status from the response" do
      VCR.use_cassette("imagen_task_retriever_success") do
        expect(task_retriever.status).to eq("COMPLETED")
      end
    end

    context "when response is not success" do
      it "raises a Freepik::ResponseError" do
        VCR.use_cassette("imagen_task_retriever_error") do
          expect { task_retriever.status }.to raise_error(::Freepik::ResponseError)
        end
      end
    end
  end

  describe "#image_url" do
    let(:image_url) do
      ["https://cdn-magnific.freepik.com/imagen3_a35022aa-611a-40a1-a792-4562a4058aab_0.png?token=exp=1761444103~hmac=70070e0512fdd937b5195b51a108b8c95363d5979f2dfe18015e888fa18f2d6d&size=stable"]
    end

    it "returns the image URL from the response" do
      VCR.use_cassette("imagen_task_retriever_success") do
        expect(task_retriever.image_url).to eq(image_url)
      end
    end

    context "when response is not success" do
      it "raises a Freepik::ResponseError" do
        VCR.use_cassette("imagen_task_retriever_error") do
          expect { task_retriever.image_url }.to raise_error(::Freepik::ResponseError)
        end
      end
    end
  end
end
