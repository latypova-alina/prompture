require "rails_helper"

describe ScriptGenerator::ForBloomy::ChainedScenes::LastSceneValidator do
  subject { described_class.new(context:).last_scene? }

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

  it { is_expected.to be(false) }

  context "when current scene is the last one" do
    let(:command_request) do
      create(
        :command_edit_image_request,
        user:,
        category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT,
        image_prompt: second_image_prompt
      )
    end

    it { is_expected.to be(true) }
  end
end
