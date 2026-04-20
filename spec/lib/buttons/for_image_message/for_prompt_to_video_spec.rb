require "rails_helper"

describe Buttons::ForImageMessage::ForPromptToVideo do
  subject(:result) { described_class.build }

  it "builds processor buttons as separate rows" do
    expect(result).to eq(
      [
        [{ callback_data: "kling_2_1_pro_image_to_video",
           text: "Kling Pro 2.1 (10 credits)" }],
        [{ callback_data: "seedance_1_5_pro_image_to_video",
           text: "Seedance Pro 1.5 (6 credits)" }],
        [{ callback_data: "wan_2_2_image_to_video",
           text: "Wan 2.2 (6 credits)" }]
      ]
    )
  end

  context "when locale is russian" do
    subject(:result) { described_class.build(locale: :ru) }

    it "builds processor buttons with russian pluralization" do
      expect(result).to eq(
        [
          [{ callback_data: "kling_2_1_pro_image_to_video",
             text: "Kling Pro 2.1 (10 кредитов)" }],
          [{ callback_data: "seedance_1_5_pro_image_to_video",
             text: "Seedance Pro 1.5 (6 кредитов)" }],
          [{ callback_data: "wan_2_2_image_to_video",
             text: "Wan 2.2 (6 кредитов)" }]
        ]
      )
    end
  end
end
