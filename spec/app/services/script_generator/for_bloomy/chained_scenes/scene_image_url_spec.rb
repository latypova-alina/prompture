require "rails_helper"

describe ScriptGenerator::ForBloomy::ChainedScenes::SceneImageUrl do
  subject { described_class.new(scene:).image_url }

  let(:user) { create(:user, :with_balance) }
  let(:script) { create(:script, chained_references: true) }
  let(:image_prompt) { create(:image_prompt) }
  let(:scene) { create(:scene, script:, order: 1, image_prompt:) }
  let(:button_request) do
    create(
      :button_image_processing_request,
      :completed,
      command_request: create(
        :command_edit_image_request,
        user:,
        category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT,
        image_prompt:
      ),
      user:
    )
  end

  it { is_expected.to be_nil }

  context "when the scene has stored images" do
    before do
      older_request = create(
        :button_image_processing_request,
        :completed,
        command_request: button_request.command_request,
        user:
      )
      create(:stored_image, image_prompt:, source_message: older_request,
                            image_url: "https://example.com/old.png",
                            created_at: 1.day.ago)
      create(:stored_image, image_prompt:, source_message: button_request,
                            image_url: "https://example.com/latest.png")
    end

    it { is_expected.to eq("https://example.com/latest.png") }
  end
end
