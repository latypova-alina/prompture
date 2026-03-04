require "rails_helper"

describe Generator::Prompt::ErrorNotifierJob do
  subject(:perform_job) do
    described_class.new.perform(chat_id, button_request.id)
  end

  let(:chat_id) { 456 }

  let(:button_request) { create(:button_extend_prompt_request) }

  let(:telegram_bot) { double }

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
  end

  describe "#perform" do
    it "sends telegram message with correct chat_id and error text" do
      expect(telegram_bot).to receive(:send_message).with(
        chat_id:,
        text: I18n.t("errors.extend_prompt_error")
      )

      perform_job
    end
  end
end
