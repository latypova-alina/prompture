require "rails_helper"

describe StoreImage::Upload::ModerationValidator do
  subject(:validate!) { described_class.new(bytes:, content_type:, moderatable:).validate! }

  let(:bytes) { "image-bytes" }
  let(:content_type) { "image/jpeg" }
  let(:moderatable) { create(:user_picture_message) }
  let(:blocked) { false }

  before { stub_openai_moderation(blocked:) }

  context "when the image is blocked" do
    let(:blocked) { true }

    it { expect { validate! }.to raise_error(ModerationError) }

    it "records the result against the image record" do
      expect { validate! }.to raise_error(ModerationError)
      expect(ModerationResult.sole).to have_attributes(
        moderatable:, command_request: moderatable.command_request, input_kind: "image", input_text: nil, blocked: true
      )
    end
  end

  context "when the image passes" do
    it { expect { validate! }.not_to raise_error }

    it "records the result against the image record" do
      validate!
      expect(ModerationResult.sole).to have_attributes(moderatable:, blocked: false)
    end
  end
end
