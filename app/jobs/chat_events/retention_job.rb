module ChatEvents
  # Conversation history is kept for 90 days. Runs daily (config/initializers/sidekiq_cron.rb).
  class RetentionJob < ApplicationJob
    RETENTION = 90.days
    BATCH_SIZE = 1_000

    def perform
      ChatEvent.where(occurred_at: ...RETENTION.ago).in_batches(of: BATCH_SIZE).delete_all
    end
  end
end
