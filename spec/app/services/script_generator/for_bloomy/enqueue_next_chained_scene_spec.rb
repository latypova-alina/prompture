require "rails_helper"

describe ScriptGenerator::ForBloomy::EnqueueNextChainedScene do
  subject(:enqueue_next) do
    described_class.call(image_url:, button_request:)
  end

  let(:image_url) { "https://example.com/scene-1.png" }
  let(:user) { create(:user, :with_balance) }
  let(:script) { create(:script, chained_references: true) }
  let(:first_image_prompt) { create(:image_prompt) }
  let(:second_image_prompt) { create(:image_prompt) }
  let!(:first_scene) { create(:scene, script:, order: 1, image_prompt: first_image_prompt) }
  let!(:second_scene) { create(:scene, script:, order: 2, image_prompt: second_image_prompt) }
  let(:command_request) do
    create(
      :command_edit_image_request,
      user:,
      chat_id: 456,
      category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT,
      image_prompt: first_image_prompt
    )
  end
  let(:button_request) do
    create(:button_image_processing_request, :completed, command_request:, user:)
  end
  let(:image_processor) { instance_double(ScriptGenerator::ProcessScene::ForEditImage) }

  before do
    allow(ScriptGenerator::ProcessScene::ForEditImage).to receive(:new)
      .with(
        chat_id: 456,
        category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT,
        reference_image_url: image_url
      )
      .and_return(image_processor)
    allow(image_processor).to receive(:call)
  end

  it "starts generation for the next scene with the completed image as reference" do
    enqueue_next

    expect(image_processor).to have_received(:call).with(image_prompt_record: second_image_prompt)
  end

  context "when script is not chained" do
    let(:script) { create(:script, chained_references: false) }

    it "does not start the next scene" do
      enqueue_next

      expect(ScriptGenerator::ProcessScene::ForEditImage).not_to have_received(:new)
    end
  end

  context "when there is no next scene" do
    let!(:second_scene) { nil }

    before { first_scene }

    it "does not start another generation" do
      enqueue_next

      expect(ScriptGenerator::ProcessScene::ForEditImage).not_to have_received(:new)
    end
  end

  context "when the next scene already has a stored image" do
    before do
      create(:stored_image, image_prompt: second_image_prompt, source_message: button_request)
    end

    it "does not start the next scene" do
      enqueue_next

      expect(ScriptGenerator::ProcessScene::ForEditImage).not_to have_received(:new)
    end
  end
end
