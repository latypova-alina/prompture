require "rails_helper"

describe Buttons::ForImageMessage::ForPromptToVideo do
  subject(:result) { described_class.build(processor: "flux_image") }

  it "builds regenerate and processor buttons" do
    expect(result).to eq(
      [
        [{ callback_data: "flux_image", text: "Regenerate (1 credit)" }],
        [{ callback_data: "kling_2_1_pro_image_to_video",
           text: "Kling Pro 2.1 (10 credits)" }]
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
             text: "Kling Pro 2.1 (10 кредитов)" }]
        ]
      )
    end
  end
end
