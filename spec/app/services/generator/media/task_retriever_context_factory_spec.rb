require "rails_helper"

describe Generator::Media::TaskRetrieverContext do
  describe ".for" do
    Generator::Processors::IMAGE.each do |image_processor|
      context "when processor is #{image_processor}" do
        let(:params) { ActionController::Parameters.new(processor: image_processor) }

        it "returns ImageTaskRetrieverContext" do
          expect(described_class.for(params:))
            .to be_a(Generator::Media::ImageTaskRetrieverContext)
        end
      end
    end

    context "when processor is not an image processor" do
      let(:params) { ActionController::Parameters.new(processor: "kling_2_1_pro_image_to_video") }

      it "returns FreepikTaskRetrieverContext" do
        expect(described_class.for(params:))
          .to be_a(Generator::Media::FreepikTaskRetrieverContext)
      end
    end
  end
end
