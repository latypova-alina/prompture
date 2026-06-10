require "rails_helper"

describe Buttons::ForImageMessage::ForPromptToVideo do
  subject(:result) { described_class.build(processor: "flux_image") }

  it "builds regenerate and processor buttons" do
    expect(result).to eq(
      [
        [{ callback_data: "flux_image", text: "Regenerate (1 credit)" }],
        [{ callback_data: "kling_2_1_pro_image_to_video",
           text: "Kling Pro 2.1 (10 credits)" }],
        [{ callback_data: "hailuo_02_standard_image_to_video",
           text: "Hailuo 02 Standard (6 credits)" }],
        [{ callback_data: "veo3_1_lite_image_to_video",
           text: "Veo 3.1 Lite (5 credits)" }]
      ]
    )
  end

  context "when locale is russian" do
    subject(:result) { described_class.build(processor: "flux_image", locale: :ru) }

    it "builds buttons with russian pluralization" do
      expect(result).to eq(
        [
          [{ callback_data: "flux_image", text: "Сгенерировать снова (1 кредит)" }],
          [{ callback_data: "kling_2_1_pro_image_to_video",
             text: "Kling Pro 2.1 (10 кредитов)" }],
          [{ callback_data: "hailuo_02_standard_image_to_video",
             text: "Hailuo 02 Standard (6 кредитов)" }],
          [{ callback_data: "veo3_1_lite_image_to_video",
             text: "Veo 3.1 Lite (5 кредитов)" }]
        ]
      )
    end
  end
end
