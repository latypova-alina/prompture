require "rails_helper"

describe CartoonScriptCheckable do
  describe "#cartoon_script?" do
    it "returns true when category is cartoon_script" do
      request = build(:command_edit_image_request, category: ContentCategory::CARTOON_SCRIPT)

      expect(request.cartoon_script?).to be(true)
    end

    it "returns false when category is blank" do
      request = build(:command_edit_image_request, category: nil)

      expect(request.cartoon_script?).to be(false)
    end

    it "returns false for command requests without category" do
      request = build(:command_image_to_video_request)

      expect(request.cartoon_script?).to be(false)
    end
  end

  it "is included in all command request models" do
    expected_models = ApplicationRecord.descendants.select { |model| model.name.start_with?("Command") }

    expected_models.each do |model|
      expect(model.ancestors).to include(CartoonScriptCheckable),
                                 "#{model.name} does not include CartoonScriptCheckable"
    end
  end
end
