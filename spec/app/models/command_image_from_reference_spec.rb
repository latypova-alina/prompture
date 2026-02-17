require "rails_helper"

describe CommandImageFromReferenceRequest, type: :model do
  describe "associations" do
    it do
      is_expected
        .to have_many(:button_image_processing_requests)
        .dependent(:destroy)
    end
  end
end
