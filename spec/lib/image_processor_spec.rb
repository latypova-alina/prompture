require "rails_helper"

describe ImageProcessor do
  let(:prompt) { "Sample prompt" }
  let(:processor_type) { "mystic_image" }
  let(:image_url) { "http://example.com/image.png" }

  subject { described_class.new(prompt, processor_type) }

  describe "#image_url" do
    subject { super().image_url }

    before do
      allow_any_instance_of(MysticImageProcessor).to receive(:image_url).and_return(image_url)
    end

    it { is_expected.to eq("http://example.com/image.png") }
  end
end
