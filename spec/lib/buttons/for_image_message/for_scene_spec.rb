require "rails_helper"

describe Buttons::ForImageMessage::ForScene do
  subject { described_class.build(locale:, processor:) }

  let(:locale) { :en }
  let(:processor) { "nano_banana_edit_image" }

  it "returns regenerate, regenerate script, and generate video buttons" do
    expect(subject).to eq(
      [
        [{ callback_data: "nano_banana_edit_image", text: "Regenerate (1 ink 🖋️✨)" }],
        [{ callback_data: "regenerate_single_cartoon_script_image", text: "Regenerate Script (1 ink 🖋️✨)" }],
        [{ callback_data: "generate_cartoon_video", text: "Generate Video (5 inks 🖋️✨)" }]
      ]
    )
  end

  context "when locale is ru" do
    let(:locale) { :ru }

    it "returns localized button labels" do
      expect(subject).to eq(
        [
          [{ callback_data: "nano_banana_edit_image", text: "Сгенерировать снова (1 инк 🖋️✨)" }],
          [{ callback_data: "regenerate_single_cartoon_script_image",
             text: "Перегенерировать сценарий (1 инк 🖋️✨)" }],
          [{ callback_data: "generate_cartoon_video", text: "Сгенерировать видео (5 инков 🖋️✨)" }]
        ]
      )
    end
  end
end
