require "rails_helper"

describe Buttons::ForImageMessage::ForPromptToVideo do
  subject(:result) { described_class.build }

  it "builds processor buttons as separate rows" do
    expect(result).to eq(
      [[{ callback_data: "kling_2_1_pro_image_to_video",
          text: "Kling Pro 2.1 (10 credits)" }]]
    )
  end
end
