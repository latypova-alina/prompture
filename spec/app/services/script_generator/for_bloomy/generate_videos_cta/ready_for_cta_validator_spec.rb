require "rails_helper"

describe ScriptGenerator::ForBloomy::GenerateVideosCta::ReadyForCtaValidator do
  subject { described_class.new(chained_scenes:).ready_for_cta? }

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
      image_prompt: second_image_prompt
    )
  end
  let(:button_request) do
    create(:button_image_processing_request, :completed, command_request:, user:)
  end
  let(:chained_scenes) { ScriptGenerator::ForBloomy::ChainedScenes::Facade.new(button_request:) }

  before do
    create(:stored_image, image_prompt: first_image_prompt, source_message: button_request,
                          image_url: "https://example.com/1.png")
    create(
      :stored_image,
      image_prompt: second_image_prompt,
      source_message: create(:button_image_processing_request, :completed, command_request:, user:),
      image_url: "https://example.com/2.png"
    )
  end

  it { is_expected.to be(true) }

  context "when current scene is not the last one" do
    let(:command_request) do
      create(
        :command_edit_image_request,
        user:,
        category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT,
        image_prompt: first_image_prompt
      )
    end

    it { is_expected.to be(false) }
  end

  context "when a scene is missing a stored image" do
    before { StoredImage.where(image_prompt: first_image_prompt).delete_all }

    it { is_expected.to be(false) }
  end
end
