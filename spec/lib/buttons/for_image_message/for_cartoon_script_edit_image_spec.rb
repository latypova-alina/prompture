require "rails_helper"

describe Buttons::ForImageMessage::ForCartoonScriptEditImage do
  subject { described_class.build(locale:, processor:) }

  let(:locale) { :en }
  let(:processor) { "nano_banana_edit_image" }

  it "returns regenerate and generate video buttons" do
    expect(subject).to eq(
      [
        [{ callback_data: "nano_banana_edit_image", text: "Regenerate (1 credit)" }],
        [{ callback_data: "generate_cartoon_video", text: "Generate Video (6 credits)" }]
      ]
    )
  end

  context "when locale is ru" do
    let(:locale) { :ru }

    it "returns localized button labels" do
      expect(subject).to eq(
        [
          [{ callback_data: "nano_banana_edit_image", text: "Сгенерировать снова (1 кредит)" }],
          [{ callback_data: "generate_cartoon_video", text: "Сгенерировать видео (6 кредитов)" }]
        ]
      )
    end
  end
end
