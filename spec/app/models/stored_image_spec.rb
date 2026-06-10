require "rails_helper"

describe StoredImage, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:source_message) }
    it { is_expected.to belong_to(:image_prompt).optional }
  end

  describe "columns" do
    it "has polymorphic source_message fields" do
      expect(described_class.column_names).to include("source_message_type", "source_message_id")
    end
  end
end
