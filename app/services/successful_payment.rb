SuccessfulPayment = Struct.new(:payment) do
  def pack_key
    payment["invoice_payload"]
  end

  def telegram_payment_charge_id
    payment["telegram_payment_charge_id"]
  end

  def stars_amount
    payment["total_amount"]
  end
end
