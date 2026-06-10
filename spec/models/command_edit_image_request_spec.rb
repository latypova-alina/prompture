require "rails_helper"

describe CommandEditImageRequest, type: :model do
  describe "#cartoon_script?" do
    it "returns true when category is cartoon_script" do
      request = build(:command_edit_image_request, category: ContentCategory::CARTOON_SCRIPT)

      expect(request.cartoon_script?).to be(true)
    end

    it "returns false when category is blank" do
      request = build(:command_edit_image_request, category: nil)

      expect(request.cartoon_script?).to be(false)
    end
  end

  describe ".cartoon_script?" do
    it "returns true for a cartoon script edit image request" do
      request = create(:command_edit_image_request, category: ContentCategory::CARTOON_SCRIPT)

      expect(described_class.cartoon_script?(request)).to be(true)
    end

    it "returns false for a non-edit-image command request" do
      request = create(:command_prompt_to_image_request, category: ContentCategory::CARTOON_SCRIPT)

      expect(described_class.cartoon_script?(request)).to be(false)
    end
  end
end
