require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::ShortComplexScript::CreateVideoRequests do
  subject(:result) { described_class.call(command_request:, scenes:) }

  let(:user) { create(:user, :with_custom_balance, credits: 50) }
  let(:command_request) do
    create(
      :command_edit_image_request,
      user:,
      category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT
    )
  end
  let(:script) { create(:script, chained_references: true) }
  let(:prompts) { Array.new(3) { create(:image_prompt) } }
  let!(:scenes) do
    prompts.each_with_index.map do |image_prompt, index|
      create(:scene, script:, order: index + 1, image_prompt:)
    end
  end

  before do
    scenes.each_with_index do |scene, index|
      create(
        :stored_image,
        image_prompt: scene.image_prompt,
        source_message: create(:button_image_processing_request, :completed, command_request:, user:),
        image_url: "https://example.com/#{index + 1}.png"
      )
    end

    allow(Generator::Media::Video::EnqueueVideoTask).to receive(:call)
  end

  it "creates consecutive two-frame requests, charges, and enqueues each video" do
    expect { result }
      .to change(CommandTwoFrameToVideoRequest, :count).by(2)
      .and change(ButtonVideoProcessingRequest, :count).by(2)
      .and change { user.balance.reload.credits }.by(-12)

    requests = CommandTwoFrameToVideoRequest.order(:id).last(2)

    expect(requests.map(&:start_image_url)).to eq(
      %w[https://example.com/1.png https://example.com/2.png]
    )
    expect(requests.map(&:end_image_url)).to eq(
      %w[https://example.com/2.png https://example.com/3.png]
    )
    expect(ButtonVideoProcessingRequest.order(:id).last(2).map(&:processor))
      .to all(eq("kling_3_standard_image_to_video"))
    expect(Generator::Media::Video::EnqueueVideoTask).to have_received(:call).twice
  end

  context "when balance is insufficient" do
    let(:user) { create(:user, :with_custom_balance, credits: 5) }

    it "fails without creating requests" do
      expect { result }
        .to change(CommandTwoFrameToVideoRequest, :count).by(0)
        .and change(ButtonVideoProcessingRequest, :count).by(0)

      expect(result).to be_failure
      expect(result.error).to eq(InsufficientCreditsError)
      expect(Generator::Media::Video::EnqueueVideoTask).not_to have_received(:call)
    end
  end
end
