require "rails_helper"

describe Flipper::Synchronizer do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          Flipper::SyncDesiredFlags,
          Flipper::RemoveStaleFlags,
          Flipper::UpdateManagedRegistry
        ]
      )
    end
  end
end
