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
end
