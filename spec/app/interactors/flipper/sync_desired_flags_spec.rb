require "rails_helper"

describe Flipper::SyncDesiredFlags do
  subject(:call) { described_class.call(desired:) }

  let(:desired) { { feature_a: true, feature_b: false } }

  describe "#call" do
    it "enables flags set to true" do
      call

      expect(Flipper.enabled?(:feature_a)).to be(true)
    end

    it "disables flags set to false" do
      Flipper.enable(:feature_b)

      call

      expect(Flipper.enabled?(:feature_b)).to be(false)
    end

    it "sets desired_keys on the context as strings" do
      expect(call.desired_keys).to contain_exactly("feature_a", "feature_b")
    end
  end
end
