require "rails_helper"

describe Buttons::ForImageMessage::ForImageToVideo do
  subject(:result) { described_class.build }

  it "builds provide prompt and processor buttons as separate rows" do
    expect(result).to eq(
      [
        [{ callback_data: "provide_prompt", text: "Provide Prompt" }],
        [{ callback_data: "kling_2_1_pro_image_to_video",
           text: "Kling Pro 2.1 (10 credits)" }]
      ]
    )
  end

  context "when locale is russian" do
    subject(:result) { described_class.build(locale: :ru) }

    it "builds provide prompt and processor buttons with russian pluralization" do
      expect(result).to eq(
        [
          [{ callback_data: "provide_prompt", text: "Указать промпт" }],
          [{ callback_data: "kling_2_1_pro_image_to_video",
             text: "Kling Pro 2.1 (10 кредитов)" }]
        ]
      )
    end
  end
end
