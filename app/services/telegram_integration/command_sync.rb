module TelegramIntegration
  class CommandSync
    include Memery

    COMMAND_NAMES = %w[
      prompt_to_video
      prompt_to_image
      prompt_to_audio
      image_to_video
      edit_image
      set_locale
      balance
      activate_token
      start
      help
      prompt_policy
    ].freeze

    DESCRIPTION_I18N_SCOPE = "telegram_webhooks.commands.description".freeze

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
      COMMAND_NAMES.map { |command| command_entry(command) }
    end

    def command_entry(command)
      {
        command:,
        description: I18n.t("#{DESCRIPTION_I18N_SCOPE}.#{command}")
      }
    end
  end
end
