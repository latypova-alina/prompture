require "rails_helper"

describe CommandPromptToVideoRequest, type: :model do
  describe "validations" do
    it "allows nil category" do
      expect(build(:command_prompt_to_video_request, category: nil)).to be_valid
    end

    it "allows normalized category values" do
      expect(build(:command_prompt_to_video_request, category: "motivation")).to be_valid
    end

    it "rejects invalid category format" do
      expect(build(:command_prompt_to_video_request, category: "Bad Category")).not_to be_valid
    end
  end

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

    it do
      is_expected
        .to have_many(:direct_button_video_processing_requests)
        .class_name("ButtonVideoProcessingRequest")
        .dependent(:destroy)
    end
  end
end
