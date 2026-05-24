require "rails_helper"

describe StoredVideo, type: :model do
  it "is valid with required attributes" do
    expect(build(:stored_video)).to be_valid
  end

  it "requires subcategory" do
    expect(build(:stored_video, subcategory: nil)).not_to be_valid
  end

  it "enforces unique source" do
    source = create(:button_video_processing_request)
    create(:stored_video, source:)

    expect(build(:stored_video, source:)).not_to be_valid
  end
end
