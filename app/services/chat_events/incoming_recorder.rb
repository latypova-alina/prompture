module ChatEvents
  # Records one incoming Telegram update. Never raises: losing a history row must not break
  # handling the user's message, so failures go to Sentry instead.
  class IncomingRecorder
    include Memery

    def self.call(...)
      new(...).call
    end

    def initialize(update)
      @update = update
    end

    def call
      return if attributes.nil?

      # update_id is unique: a Telegram retry of the same update is skipped, not recorded twice.
      ChatEvent.insert(attributes.merge(user_id:), unique_by: :update_id)
    rescue StandardError => e
      Sentry.capture_exception(e)
    end

    private

    attr_reader :update

    delegate :attributes, to: :incoming_update

    memoize def incoming_update
      ChatEvents::IncomingUpdate.new(update)
    end

    def user_id
      ChatEvents::UserLookup.call(attributes[:chat_id])
    end
  end
end
