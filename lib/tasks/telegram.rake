namespace :telegram do
  task set_commands: :environment do
    bot = Telegram::Bot::Client.new(token: ENV.fetch("TELEGRAM_BOT_TOKEN"))

    Rails.application.config.x.supported_locales.each do |locale|
      I18n.with_locale(locale) do
        bot.set_my_commands(
          commands: [
            { command: "start", description: I18n.t("telegram_webhooks.commands.description.start") },
            { command: "help", description: I18n.t("telegram_webhooks.commands.description.help") },
            { command: "balance", description: I18n.t("telegram_webhooks.commands.description.balance") },
            { command: "token", description: I18n.t("telegram_webhooks.commands.description.token") },
            { command: "prompt_to_video",
              description: I18n.t("telegram_webhooks.commands.description.prompt_to_video") },
            { command: "prompt_to_image",
              description: I18n.t("telegram_webhooks.commands.description.prompt_to_image") },
            { command: "set_locale",
              description: I18n.t("telegram_webhooks.commands.description.set_locale") }
          ],
          language_code: locale
        )
      end
    end
  end
end
