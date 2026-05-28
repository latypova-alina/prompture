require "rails_helper"

describe Generator::Media::TaskRetrieverContext do
  describe ".for" do
    %w[flux_image nano_banana_image].each do |fal_processor|
      context "when processor is #{fal_processor}" do
        let(:params) { ActionController::Parameters.new(processor: fal_processor) }

        it "returns FluxTaskRetrieverContext" do
          expect(described_class.for(params:))
            .to be_a(Generator::Media::FluxTaskRetrieverContext)
        end
      end
    end

    context "when processor is not a FAL image processor" do
      let(:params) { ActionController::Parameters.new(processor: "imagen_image") }

      it "returns FreepikTaskRetrieverContext" do
        expect(described_class.for(params:))
          .to be_a(Generator::Media::FreepikTaskRetrieverContext)
      end
    end
  end
end
