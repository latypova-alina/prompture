require "rails_helper"

describe ScriptGenerator::ForBloomy::ChainedScenes::AllImagesReadyValidator do
  subject { described_class.new(context:).all_images_ready? }

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
      category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT,
      image_prompt: first_image_prompt
    )
  end
  let(:button_request) do
    create(:button_image_processing_request, :completed, command_request:, user:)
  end
  let(:context) { ScriptGenerator::ForBloomy::ChainedScenes::Context.new(button_request:) }

  before do
    create(:stored_image, image_prompt: first_image_prompt, source_message: button_request,
                          image_url: "https://example.com/1.png")
  end

  it { is_expected.to be(false) }

  context "when every scene has a stored image" do
    before do
      create(
        :stored_image,
        image_prompt: second_image_prompt,
        source_message: create(:button_image_processing_request, :completed, command_request:, user:),
        image_url: "https://example.com/2.png"
      )
    end

    it { is_expected.to be(true) }
  end
end
