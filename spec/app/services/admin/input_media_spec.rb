require "rails_helper"

describe Admin::InputMedia do
  subject { described_class.call(input) }

  context "when it is a picture with a stored copy" do
    let(:input) { create(:user_picture_message) }

    before { create(:stored_image, source_message: input, image_url: "https://bucket.example.com/p.jpg") }

    it { is_expected.to have_attributes(label: "Input image", kind: :image, url: "https://bucket.example.com/p.jpg") }
  end

  context "when it is a picture without a stored copy yet" do
    let(:input) { create(:user_picture_message) }

    it { is_expected.to be_nil }
  end

  context "when it is an image URL message" do
    let(:input) { create(:user_image_url_message, image_url: "https://example.com/original.png") }

    it { is_expected.to have_attributes(url: "https://example.com/original.png") }
  end

  context "when it is a prompt message" do
    let(:input) { create(:prompt_message) }

    it { is_expected.to be_nil }
  end
end
