require "rails_helper"
require "telegram/bot/rspec/integration/rails"

describe TelegramWebhooksController, telegram_bot: :rails do
  include_context "telegram/bot/callback_query"
  let(:prompt) { "cute white kitten" }

  describe "#start!" do
    subject { -> { dispatch_command :start } }

    let(:expected_text) { "Hi there! Please choose a command from the menu list." }

    it { is_expected.to respond_with_message(expected_text) }
  end

  describe "#prompt_to_video!" do
    subject { -> { dispatch_command :prompt_to_video } }

    let(:expected_text) do
      "Great! Now please provide a prompt for the video. The prompt can be in any language and any length, " \
      "and it can later be adapted with the help of the bot."
    end

    it { is_expected.to respond_with_message(expected_text) }
  end

  describe "#prompt_to_image!" do
    subject { -> { dispatch_command :prompt_to_image } }

    let(:expected_text) do
      "Great! Now please provide a prompt for the image. The prompt can be in any language and any length, " \
      "and it can later be adapted with the help of the bot."
    end

    it { is_expected.to respond_with_message(expected_text) }
  end

  describe "#message" do
    subject { -> { dispatch_message(prompt) } }

    context "when command was not selected" do
      let(:expected_text) do
        "Oops! It looks like you haven’t selected a command yet. Please choose one and follow the instructions."
      end

      it { is_expected.to respond_with_message(expected_text) }
    end

    context "when command is known" do
      let(:session) { FakeSession.new }
      let(:command) { "prompt_to_image" }

      before do
        allow_any_instance_of(described_class)
          .to receive(:session)
          .and_return(session)

        session[:command] = command
        session[:chat_id] = 456

        CommandPromptToImageRequest.create!(prompt:, chat_id: 456)
      end

      let(:expected_message) do
        <<~HTML.strip
          Here is your prompt:

          <blockquote>cute white kitten</blockquote>

          What do you want to do next?
        HTML
      end

      let(:expected_markup) do
        {
          inline_keyboard: [
            [{ text: "Extend prompt", callback_data: "extend_prompt" }],
            [{ text: "Gemini (0.035€)", callback_data: "gemini_image" }],
            [{ text: "Imagen3 (0.04€)", callback_data: "imagen_image" }],
            [{ text: "Mystic (0.1€)", callback_data: "mystic_image" }]
          ]
        }
      end

      it "replies with MessagePresenter data" do
        expect { dispatch_message(prompt) }
          .to send_telegram_message(bot)
          .with(
            text: "#{expected_message}\n",
            parse_mode: "HTML",
            reply_markup: expected_markup,
            chat_id: 456
          )
      end
    end
  end

  describe "#extend_prompt_callback_query", :callback_query do
    let(:session) { FakeSession.new }
    let(:chat_id) { 456 }
    let(:command) { "prompt_to_image" }
    let(:button_request) { "extend_prompt" }
    let(:callback_query_data) do
      {
        "callback_query" => {
          "message" => {
            "entities" => [],
            "message_id" => 789
          }
        }
      }
    end
    let(:button_extend_prompt_request) do
      create(:button_extend_prompt_request,
             prompt: "cute white kitten extended",
             command_request:,
             parent_request: command_request)
    end

    let(:command_request) { create(:command_prompt_to_image_request, prompt: "cute white kitten", chat_id:) }

    before do
      allow_any_instance_of(described_class)
        .to receive(:session)
        .and_return(session)

      session[:command] = command

      allow_any_instance_of(described_class)
        .to receive(:chat)
        .and_return({ "id" => chat_id })

      allow_any_instance_of(described_class)
        .to receive(:update)
        .and_return(callback_query_data)

      create(:telegram_message, tg_message_id: 789, chat_id:, request: command_request)

      allow_any_instance_of(RecordCreators::ButtonRequests::ExtendPrompt)
        .to receive(:record)
        .and_return(button_extend_prompt_request)
    end

    it "runs ::Generator::Prompt::ExtendJob" do
      expect(::Generator::Prompt::ExtendJob).to receive(:perform_async)
        .with("cute white kitten", 456, button_extend_prompt_request.id)

      described_class.new.callback_query(button_request)
    end
  end

  describe "#mystic_image_callback_query", :callback_query do
    let(:session) { FakeSession.new }
    let(:chat_id) { 456 }
    let(:command) { "prompt_to_image" }
    let(:button_request) { "mystic_image" }
    let(:callback_query_data) do
      {
        "callback_query" => {
          "message" => {
            "entities" => [],
            "message_id" => 789
          }
        }
      }
    end
    let(:button_image_processing_request) do
      create(:button_image_processing_request,
             processor: "mystic",
             command_request:,
             parent_request: command_request)
    end

    let(:command_request) { create(:command_prompt_to_image_request, prompt: "cute white kitten", chat_id:) }

    before do
      allow_any_instance_of(described_class)
        .to receive(:session)
        .and_return(session)

      session[:command] = command

      allow_any_instance_of(described_class)
        .to receive(:chat)
        .and_return({ "id" => chat_id })

      allow_any_instance_of(described_class)
        .to receive(:update)
        .and_return(callback_query_data)

      create(:telegram_message, tg_message_id: 789, chat_id:, request: command_request)

      allow_any_instance_of(RecordCreators::ButtonRequests::Images::Mystic)
        .to receive(:record)
        .and_return(button_image_processing_request)
    end

    it "runs ::Generator::Image::Mystic::TaskCreatorJob" do
      expect(::Generator::Image::Mystic::TaskCreatorJob).to receive(:perform_async)
        .with("cute white kitten", 456, "mystic_image", button_image_processing_request.id)

      described_class.new.callback_query(button_request)
    end
  end
end
