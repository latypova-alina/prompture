require "rails_helper"

describe Buttons::ForImageMessage::ForEditImage do
  describe ".build" do
    subject(:result) { described_class.build(processor:) }

    let(:processor) { "nano_banana_edit_image" }

    it "returns regenerate button row using edit image cost" do
      expect(result).to eq(
        [[{ callback_data: "nano_banana_edit_image", text: "Regenerate (1 credit)" }]]
      )
    end
  end
end
