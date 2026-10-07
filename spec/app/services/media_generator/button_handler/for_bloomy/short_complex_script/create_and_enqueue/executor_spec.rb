require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::ShortComplexScript::CreateAndEnqueue::Executor do
  subject(:call_service) do
    described_class.call(start_scene:, end_scene:, command_request:)
  end

  let(:credits) { 50 }
  let(:user) { create(:user, :with_custom_balance, credits:) }
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

  context "when the user can't afford the video" do
    let(:credits) { 0 }
    let(:insufficient_credits_failure) { { status: "FAILED", failure_reason: "insufficient_credits" } }

    it { expect { call_service }.to raise_error(InsufficientCreditsError) }

    it "marks the created video request as failed" do
      expect { call_service }.to raise_error(InsufficientCreditsError)

      expect(ButtonVideoProcessingRequest.sole).to have_attributes(insufficient_credits_failure)
    end

    it "doesn't enqueue the video" do
      expect { call_service }.to raise_error(InsufficientCreditsError)

      expect(Generator::Media::Video::EnqueueVideoTask).not_to have_received(:call)
    end
  end
end
