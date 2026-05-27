require "rails_helper"

describe Generator::Media::TaskRetrieverContext do
  describe ".for" do
    context "when processor is flux_image" do
      let(:params) { ActionController::Parameters.new(processor: "flux_image") }

      it "returns FluxTaskRetrieverContext" do
        expect(described_class.for(params:))
          .to be_a(Generator::Media::FluxTaskRetrieverContext)
      end
    end

    context "when processor is not flux_image" do
      let(:params) { ActionController::Parameters.new(processor: "mystic_image") }

      it "returns FreepikTaskRetrieverContext" do
        expect(described_class.for(params:))
          .to be_a(Generator::Media::FreepikTaskRetrieverContext)
      end
    end
  end
end
