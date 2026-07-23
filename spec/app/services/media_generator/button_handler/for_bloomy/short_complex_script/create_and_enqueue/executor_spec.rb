require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::ShortComplexScript::CreateAndEnqueue::Executor do
  subject(:call_service) do
    described_class.call(start_scene:, end_scene:, command_request:)
  end

  let(:user) { create(:user, :with_custom_balance, credits: 50) }
  let(:command_request) do
    create(
      :command_edit_image_request,
      user:,
      category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT
    )
  end
  let(:script) { create(:script, chained_references: true) }
  let(:start_prompt) { create(:image_prompt) }
  let(:end_prompt) { create(:image_prompt) }
  let(:start_scene) { create(:scene, script:, order: 1, image_prompt: start_prompt) }
  let(:end_scene) { create(:scene, script:, order: 2, image_prompt: end_prompt) }

  before do
    create(
      :stored_image,
      image_prompt: start_prompt,
      source_message: create(:button_image_processing_request, :completed, command_request:, user:),
      image_url: "https://example.com/start.png"
    )
    create(
      :stored_image,
      image_prompt: end_prompt,
      source_message: create(:button_image_processing_request, :completed, command_request:, user:),
      image_url: "https://example.com/end.png"
    )
    allow(Generator::Media::Video::EnqueueVideoTask).to receive(:call)
  end

  it "creates requests, charges, and enqueues the video" do
    expect { call_service }
      .to change(CommandTwoFrameToVideoRequest, :count).by(1)
      .and change(ButtonVideoProcessingRequest, :count).by(1)
      .and change { user.balance.reload.credits }.by(-6)

    expect(Generator::Media::Video::EnqueueVideoTask).to have_received(:call).with(
      an_instance_of(ButtonVideoProcessingRequest)
    )
  end
end
