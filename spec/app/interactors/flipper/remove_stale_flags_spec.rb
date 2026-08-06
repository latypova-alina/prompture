require "rails_helper"

describe Flipper::RemoveStaleFlags do
  subject(:call) { described_class.call(desired_keys:) }

  let(:desired_keys) { %w[feature_a feature_b] }

  describe "#call" do
    context "when a previously managed flag is removed from desired" do
      before do
        FlipperManagedFeature.create!(feature_key: "feature_c")
        Flipper.enable(:feature_c)
      end

      it "fully removes the feature, not just its boolean gate" do
        call

        expect(Flipper.feature(:feature_c).exist?).to be(false)
      end
    end

    context "when a flag was never file-managed" do
      before do
        Flipper.enable_group(:manual_flag, :admins)
      end

      it "does not remove it" do
        call

        expect(Flipper.feature(:manual_flag).exist?).to be(true)
      end

      it "does not touch its other gates" do
        call

        expect(Flipper.feature(:manual_flag).gate_values.groups).to include("admins")
      end
    end
  end
end
