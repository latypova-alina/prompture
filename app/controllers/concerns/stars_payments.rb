module StarsPayments
  extend ActiveSupport::Concern

  def buy_inks!(*)
    raise FeatureUnderDevelopmentError unless Flipper.enabled?(:stars_payments, user)

    StarsPayment::CommandHandler::HandleCommand.call(
      chat_id: chat["id"],
      locale: normalized_locale
    )
  end

  def pre_checkout_query(payload)
    return answer_pre_checkout_query(true) if valid_pack?(payload)

    answer_pre_checkout_query(false, error_message: t("errors.pack_not_found"))
  end

  private

  def valid_pack?(payload)
    CREDIT_PACKS.key?(payload["invoice_payload"].to_sym)
  end
end
