require "rails_helper"

describe Strategies::GenerateImage do
  let(:session) { { "prompt" => "generate image prompt" } }
  let(:processor_type) { "mystic" }
  let(:processor_object) { double(image_url: "https://example.com/image.png") }
  let(:presenter_object) { double(reply_data: "reply data") }

  subject { described_class.new(session, processor_type) }

  describe "#reply_data" do
    subject { super().reply_data }

    before do
      allow(ImageProcessor).to receive(:new)
        .with("generate image prompt", processor_type).and_return(processor_object)

      allow(ButtonMessagePresenter).to receive(:new)
        .with("https://example.com/image.png", "image_message", processor_type, true).and_return(presenter_object)
    end

    it { is_expected.to eq("reply data") }
  end
end
