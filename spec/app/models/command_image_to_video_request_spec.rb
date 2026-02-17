require "rails_helper"

describe CommandImageToVideoRequest, type: :model do
  describe "associations" do
    it do
      is_expected
        .to have_many(:button_video_processing_requests)
        .dependent(:destroy)
    end
  end
end
