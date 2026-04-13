require "rails_helper"

describe TelegramIntegration::CommandSync do
  subject(:sync) { described_class.call }

  let(:bot) { instance_double(Telegram::Bot::Client) }
  let(:token) { "fake-token" }

  let(:supported_locales) { %w[en ru] }

  before do
    allow(ENV).to receive(:fetch)
      .with("TELEGRAM_BOT_TOKEN")
      .and_return(token)

    allow(Telegram::Bot::Client)
      .to receive(:new)
      .with(token: token)
      .and_return(bot)

    allow(bot).to receive(:delete_my_commands)
    allow(bot).to receive(:set_my_commands)

    allow(Rails.application.config.x)
      .to receive(:supported_locales)
      .and_return(supported_locales)

    allow(I18n).to receive(:with_locale).and_yield
    allow(I18n).to receive(:t).and_return("desc")
    allow($stdout).to receive(:puts)
  end

  describe ".call" do
    it "clears default and private scope commands" do
      sync

      expect(bot).to have_received(:delete_my_commands).with(no_args)
      expect(bot).to have_received(:delete_my_commands)
        .with(scope: { type: "all_private_chats" })
    end

    it "sets default commands" do
      sync

      expect(bot).to have_received(:set_my_commands)
        .with(commands: kind_of(Array))
    end

    it "sets default commands in expected order" do
      sync

      expected_commands = [
        { command: "prompt_to_video", description: "desc" },
        { command: "prompt_to_image", description: "desc" },
        { command: "image_to_video", description: "desc" },
        { command: "set_locale", description: "desc" },
        { command: "balance", description: "desc" },
        { command: "activate_token", description: "desc" },
        { command: "start", description: "desc" },
        { command: "help", description: "desc" },
        { command: "prompt_policy", description: "desc" }
      ]

      expect(bot).to have_received(:set_my_commands).with(commands: expected_commands)
    end

    it "sets commands for each supported locale" do
      sync

      supported_locales.each do |locale|
        expect(bot).to have_received(:set_my_commands)
          .with(
            commands: kind_of(Array),
            language_code: locale,
            scope: { type: "all_private_chats" }
          )
      end
    end

    it "prints success message" do
      sync

      expect($stdout)
        .to have_received(:puts)
        .with("Telegram commands successfully synced")
    end
  end
end
