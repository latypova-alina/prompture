require "rails_helper"

describe Buttons::ForImageMessage::ForPromptToVideo do
  subject(:result) { described_class.build(processor:) }

  let(:processor) { "flux_image" }

  it "builds processor buttons as separate rows" do
    expect(result).to eq(
      [
        [{ callback_data: "flux_image",
           text: "Regenerate (1 credit)" }],
        [{ callback_data: "kling_2_1_pro_image_to_video",
           text: "Kling Pro 2.1 (10 credits)" }],
        [{ callback_data: "wan_2_2_image_to_video",
           text: "Wan 2.2 (8 credits)" }]
      ]
    )
  end

  context "when locale is russian" do
    subject(:result) { described_class.build(processor:, locale: :ru) }

    it "builds processor buttons with russian pluralization" do
      expect(result).to eq(
        [
          [{ callback_data: "flux_image",
             text: "Сгенерировать снова (1 кредит)" }],
          [{ callback_data: "kling_2_1_pro_image_to_video",
             text: "Kling Pro 2.1 (10 кредитов)" }],
          [{ callback_data: "wan_2_2_image_to_video",
             text: "Wan 2.2 (8 кредитов)" }]
        ]
      )
    end
  end
end
