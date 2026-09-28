module TermsGate
  class AcknowledgeCallbackQuery
    include Interactor

    delegate :callback_query_id, to: :context

    def call
      return if callback_query_id.blank?

      Telegram.bot.answer_callback_query(callback_query_id:)
    rescue Telegram::Bot::Error
      nil
    end
  end
end
