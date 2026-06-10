require "rails_helper"

describe CommandPromptToImageRequest, type: :model do
  describe "associations (command_request side)" do
    it do
      is_expected
        .to have_many(:button_extend_prompt_requests)
        .dependent(:destroy)
    end

    it do
      is_expected
        .to have_many(:button_image_processing_requests)
        .dependent(:destroy)
    end

    it do
      is_expected
        .to have_many(:button_video_processing_requests)
        .dependent(:destroy)
    end

    it do
      is_expected
        .to have_many(:prompt_messages)
        .dependent(:destroy)
    end
  end

  describe "validations" do
    it "allows nil category" do
      expect(build(:command_prompt_to_image_request, category: nil)).to be_valid
    end

    it "rejects invalid category format" do
      expect(build(:command_prompt_to_image_request, category: "Invalid Category")).not_to be_valid
    end
  end

  describe "associations (parent_request side)" do
    it do
      is_expected
        .to have_many(:direct_button_extend_prompt_requests)
        .class_name("ButtonExtendPromptRequest")
        .dependent(:destroy)
    end

    it do
      is_expected
        .to have_many(:direct_button_image_processing_requests)
        .class_name("ButtonImageProcessingRequest")
        .dependent(:destroy)
    end
  end
end
