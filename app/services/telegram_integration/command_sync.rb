module TelegramIntegration
  class CommandSync
    include Memery

    def self.call
      new.call
    end

    def call
      clear_commands
      sync_default_commands
      sync_multilanguage_commands

      puts "Telegram commands successfully synced"
    end

    private

    memoize def bot
      Telegram::Bot::Client.new(token: ENV.fetch("TELEGRAM_BOT_TOKEN"))
    end

    def clear_commands
      bot.delete_my_commands
      bot.delete_my_commands(scope: { type: "all_private_chats" })
    end

    def sync_default_commands
      I18n.with_locale(:en) do
        bot.set_my_commands(commands: build_commands)
      end
    end

    def sync_multilanguage_commands
      Rails.application.config.x.supported_locales.each do |locale|
        I18n.with_locale(locale) do
          bot.set_my_commands(
            commands: build_commands,
            language_code: locale,
            scope: { type: "all_private_chats" }
          )
        end
      end
    end

    def build_commands
      [
        { command: "start", description: I18n.t("telegram_webhooks.commands.description.start") },
        { command: "help", description: I18n.t("telegram_webhooks.commands.description.help") },
        { command: "balance", description: I18n.t("telegram_webhooks.commands.description.balance") },
        { command: "activate_token", description: I18n.t("telegram_webhooks.commands.description.activate_token") },
        { command: "prompt_to_video",
          description: I18n.t("telegram_webhooks.commands.description.prompt_to_video") },
        { command: "prompt_to_image",
          description: I18n.t("telegram_webhooks.commands.description.prompt_to_image") },
        { command: "set_locale",
          description: I18n.t("telegram_webhooks.commands.description.set_locale") },
        { command: "prompt_policy",
          description: I18n.t("telegram_webhooks.commands.description.prompt_policy") }
      ]
    end
  end
end
