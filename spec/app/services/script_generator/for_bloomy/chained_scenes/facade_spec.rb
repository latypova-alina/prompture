require "rails_helper"

describe ScriptGenerator::ForBloomy::ChainedScenes::Facade do
  subject(:chained_scenes) { described_class.new(button_request:) }

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

  describe "#can_start_next_scene?" do
    it { expect(chained_scenes.can_start_next_scene?).to be(true) }

    context "when next scene already has a stored image" do
      before do
        create(:stored_image, image_prompt: second_image_prompt, source_message: button_request)
      end

      it { expect(chained_scenes.can_start_next_scene?).to be(false) }
    end
  end

  describe "#last_scene?" do
    it { expect(chained_scenes.last_scene?).to be(false) }

    context "when current scene is the last one" do
      let(:command_request) do
        create(
          :command_edit_image_request,
          user:,
          category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT,
          image_prompt: second_image_prompt
        )
      end

      it { expect(chained_scenes.last_scene?).to be(true) }
    end
  end

  describe "#all_images_ready?" do
    before do
      create(:stored_image, image_prompt: first_image_prompt, source_message: button_request,
                            image_url: "https://example.com/1.png")
    end

    it { expect(chained_scenes.all_images_ready?).to be(false) }

    context "when every scene has a stored image" do
      before do
        create(
          :stored_image,
          image_prompt: second_image_prompt,
          source_message: create(:button_image_processing_request, :completed, command_request:, user:),
          image_url: "https://example.com/2.png"
        )
      end

      it { expect(chained_scenes.all_images_ready?).to be(true) }
    end
  end
end
