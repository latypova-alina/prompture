namespace :telegram do
  task sync_commands: :environment do
    TelegramIntegration::CommandSync.call
  end
end
