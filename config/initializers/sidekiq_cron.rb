require "sidekiq/web"
require "sidekiq/cron/web"

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq::Cron::Job.create(
      name: "Database backup - daily",
      cron: "0 3 * * *",
      class: "DatabaseBackupJob"
    )
  end
end
