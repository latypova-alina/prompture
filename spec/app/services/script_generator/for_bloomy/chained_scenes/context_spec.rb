require "rails_helper"

describe ScriptGenerator::ForBloomy::ChainedScenes::Context do
  subject(:context) { described_class.new(button_request:) }

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

  describe "#scene" do
    it { expect(context.scene).to eq(first_scene) }

    context "when image_prompt_id is blank" do
      let(:command_request) do
        create(
          :command_edit_image_request,
          user:,
          category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT,
          image_prompt: nil
        )
      end

      it { expect(context.scene).to be_nil }
    end
  end

  describe "#script" do
    it { expect(context.script).to eq(script) }
  end

  describe "#scenes" do
    it { expect(context.scenes).to contain_exactly(first_scene, second_scene) }
  end

  describe "#next_scene" do
    it { expect(context.next_scene).to eq(second_scene) }

    context "when script is not chained" do
      let(:script) { create(:script, chained_references: false) }

      it { expect(context.next_scene).to be_nil }
    end

    context "when current scene is the last one" do
      let(:command_request) do
        create(
          :command_edit_image_request,
          user:,
          category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT,
          image_prompt: second_image_prompt
        )
      end

      it { expect(context.next_scene).to be_nil }
    end
  end
end
