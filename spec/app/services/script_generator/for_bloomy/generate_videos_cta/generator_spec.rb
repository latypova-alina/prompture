require "rails_helper"

describe ScriptGenerator::ForBloomy::GenerateVideosCta::Generator do
  subject(:send_cta) { described_class.call(button_request:) }

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

  before do
    create(:stored_image, image_prompt: first_image_prompt, source_message: button_request,
                          image_url: "https://example.com/1.png")
    create(
      :stored_image,
      image_prompt: second_image_prompt,
      source_message: create(:button_image_processing_request, :completed, command_request:, user:),
      image_url: "https://example.com/2.png"
    )
    allow(TelegramIntegration::SendMessageWithButtons).to receive(:call)
  end

  it "sends the CTA message bound to the command request" do
    send_cta

    expect(TelegramIntegration::SendMessageWithButtons).to have_received(:call) do |args|
      expect(args[:request]).to eq(command_request)
      expect(args[:reply_data][:text]).to eq(
        I18n.t("telegram_webhooks.message.bloomy_complex.all_images_generated")
      )
      expect(args[:reply_data][:reply_markup][:inline_keyboard]).to eq(
        [[{
          callback_data: ButtonActions::GENERATE_BLOOMY_COMPLEX_VIDEOS,
          text: "Generate videos (6 stones 🪨)"
        }]]
      )
    end
  end

  context "when current scene is not the last one" do
    let(:command_request) do
      create(
        :command_edit_image_request,
        user:,
        category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT,
        image_prompt: first_image_prompt
      )
    end

    it "does not send the CTA" do
      send_cta

      expect(TelegramIntegration::SendMessageWithButtons).not_to have_received(:call)
    end
  end

  context "when a scene is missing a stored image" do
    before { StoredImage.where(image_prompt: first_image_prompt).delete_all }

    it "does not send the CTA" do
      send_cta

      expect(TelegramIntegration::SendMessageWithButtons).not_to have_received(:call)
    end
  end
end
