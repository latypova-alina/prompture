require "rails_helper"

describe Admin::ButtonRequestInputModerations do
  subject { described_class.call(button_request) }

  let(:command_request) { create(:command_image_to_video_request) }
  let(:picture) { create(:user_picture_message, command_request:, parent_request: command_request) }
  let(:prompt) { create(:prompt_message, command_request:, parent_request: picture) }
  let(:button_request) { create(:button_video_processing_request, command_request:, parent_request: prompt) }

  let!(:prompt_result) { create(:moderation_result, command_request:, moderatable: prompt) }
  let!(:picture_result) do
    create(:moderation_result, :blocked, command_request:, moderatable: picture, input_kind: "image", input_text: nil)
  end

  it { is_expected.to eq(prompt => [prompt_result], picture => [picture_result]) }

  context "when the parent is the generated image it animates" do
    let(:image_request) { create(:button_image_processing_request) }
    let(:button_request) { create(:button_video_processing_request, parent_request: image_request) }
    let!(:image_result) do
      create(:moderation_result, command_request: image_request.command_request, moderatable: image_request,
                                 input_kind: "image", input_text: nil)
    end

    it { is_expected.to eq(image_request => [image_result]) }
  end

  context "when the prompt was written for the command, not a picture" do
    let(:command_request) { create(:command_prompt_to_image_request) }
    let(:prompt) { create(:prompt_message, command_request:, parent_request: command_request) }
    let(:button_request) { create(:button_image_processing_request, command_request:, parent_request: prompt) }
    let!(:picture_result) { nil }

    it { is_expected.to eq(prompt => [prompt_result]) }
  end

  context "when no input was moderated" do
    let!(:prompt_result) { nil }
    let!(:picture_result) { nil }

    it { is_expected.to eq({}) }
  end
end
