require "rails_helper"

describe StoreMedia::Upload::ContentTypeResolver do
  subject(:content_type) { described_class.new(filename:).content_type }

  context "when filename is a jpeg image" do
    let(:filename) { "photo.jpg" }

    it { is_expected.to eq("image/jpeg") }
  end

  context "when filename is an mp3" do
    let(:filename) { "voice.mp3" }

    it { is_expected.to eq("audio/mpeg") }
  end

  context "when extension is unsupported" do
    let(:filename) { "file.xyz" }

    it "raises argument error" do
      expect { content_type }.to raise_error(ArgumentError, "Unsupported media extension: .xyz")
    end
  end
end
