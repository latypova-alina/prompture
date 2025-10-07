require "rails_helper"

describe MysticImageProcessor do
  let(:prompt) { "A mystical forest" }
  let(:processor) { MysticImageProcessor.new(prompt) }
  let(:interactor_result) do
    double(
      failure?: false, image_url: [
        "http://example.com/image1", "http://example.com/image2"
      ]
    )
  end

  describe "#image_url" do
    context "when BuildMysticImage call is successful" do
      before do
        allow(BuildMysticImage::BuildMysticImage).to receive(:call).with(prompt:).and_return(interactor_result)
      end

      it "returns the last image URL" do
        expect(processor.image_url).to eq("http://example.com/image2")
      end
    end

    context "when BuildMysticImage call fails" do
      let(:interactor_result) { double(failure?: true) }

      before do
        allow(BuildMysticImage::BuildMysticImage).to receive(:call).with(prompt:).and_return(interactor_result)
      end

      it "returns nil" do
        expect(processor.image_url).to be_nil
      end
    end
  end
end
