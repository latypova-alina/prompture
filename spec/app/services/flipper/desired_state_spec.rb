require "rails_helper"

describe Flipper::DesiredState do
  describe ".call" do
    around do |example|
      original = ENV.to_hash
      example.run
      ENV.replace(original)
    end

    before do
      stub_const("FLIPPER_FEATURES", { flipper_feature_a: "desc a", flipper_feature_b: "desc b" })
    end

    it "reads each key's value from the matching uppercased ENV var" do
      ENV["FLIPPER_FEATURE_A"] = "true"
      ENV["FLIPPER_FEATURE_B"] = "false"

      expect(described_class.call).to eq(flipper_feature_a: true, flipper_feature_b: false)
    end

    it "defaults to false when the ENV var is unset" do
      ENV.delete("FLIPPER_FEATURE_A")

      expect(described_class.call[:flipper_feature_a]).to be(false)
    end

    it "treats any value other than the literal string true as false" do
      ENV["FLIPPER_FEATURE_A"] = "yes"

      expect(described_class.call[:flipper_feature_a]).to be(false)
    end
  end
end
