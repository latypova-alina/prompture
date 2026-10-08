require "rails_helper"
require "telegram/bot/rspec/integration/rails"

# Every text prompt's moderation is stored: a passed prompt is linked to its PromptMessage, a blocked
# one keeps its text on the moderation result and never becomes a PromptMessage.
describe TelegramWebhooksController, telegram_bot: :rails do
  subject(:moderation_result) do
    dispatch(update)
    ModerationResult.sole
  end

  let(:chat_id) { 456 }
  let!(:user) { create(:user, :with_balance, chat_id:) }
  let!(:command_request) { create(:command_prompt_to_image_request, user:, chat_id:) }
  let(:session) { FakeSession.new.tap { |session| session[:command] = "prompt_to_image" } }
  let(:blocked) { false }

  let(:update) do
    { message: { message_id: 789, date: Time.current.to_i, text: "cute white kitten",
                 chat: { id: chat_id }, from: { id: chat_id } } }
  end

  before do
    allow_any_instance_of(described_class).to receive(:session).and_return(session)
    stub_openai_moderation(blocked:)
  end

  context "when the prompt passes" do
    it { is_expected.to have_attributes(blocked: false, command_request:, moderatable: PromptMessage.sole) }
  end

  context "when the prompt is blocked" do
    let(:blocked) { true }

    it { is_expected.to have_attributes(blocked: true, input_text: "cute white kitten", moderatable: nil) }

    it "creates no PromptMessage" do
      moderation_result

      expect(PromptMessage.count).to eq(0)
    end
  end
end
