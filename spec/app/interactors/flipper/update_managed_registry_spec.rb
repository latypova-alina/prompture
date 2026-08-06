require "rails_helper"

describe Flipper::UpdateManagedRegistry do
  subject(:call) { described_class.call(desired_keys:) }

  let(:desired_keys) { %w[feature_a feature_b] }

  describe "#call" do
    it "registers the desired flags as managed" do
      call

      expect(FlipperManagedFeature.pluck(:feature_key)).to contain_exactly("feature_a", "feature_b")
    end

    context "when a previously managed flag is removed from desired" do
      before { FlipperManagedFeature.create!(feature_key: "feature_c") }

      it "removes it from the managed registry" do
        call

        expect(FlipperManagedFeature.pluck(:feature_key)).not_to include("feature_c")
      end
    end

    context "when a flag was never file-managed" do
      before { Flipper.enable_group(:manual_flag, :admins) }

      it "does not add it to the managed registry" do
        call

        expect(FlipperManagedFeature.pluck(:feature_key)).not_to include("manual_flag")
      end
    end
  end
end
