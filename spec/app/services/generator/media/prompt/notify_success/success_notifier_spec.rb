require "rails_helper"

describe Generator::Media::Prompt::NotifySuccess::SuccessNotifier do
  subject(:call_service) do
    described_class.call(extended_prompt:, button_request_id: button_request.id)
  end

  let(:extended_prompt) { "Extended prompt text" }
  let(:balance) { 6 }
  let(:user) { create(:user, :with_custom_balance, credits: balance) }

  let(:button_request) do
    create(:button_extend_prompt_request, status: "PENDING", user:)
  end

  let(:presenter_instance) { double }
  let(:reply_data) { { text: "done" } }

  before do
    allow(MediaGenerator::ButtonRequestPresenters::ExtendedPromptMessagePresenter)
      .to receive(:new)
      .with(message: extended_prompt, balance:, locale: "en")
      .and_return(presenter_instance)

    allow(presenter_instance)
      .to receive(:reply_data)
      .and_return(reply_data)

    allow(Generator::Media::Prompt::NotifySuccess::SendTelegramMessage)
      .to receive(:call)
  end

  describe ".call" do
    it "sends telegram message and updates request status" do
      call_service

      expect(MediaGenerator::ButtonRequestPresenters::ExtendedPromptMessagePresenter)
        .to have_received(:new)
        .with(message: extended_prompt, balance:, locale: "en")

      expect(Generator::Media::Prompt::NotifySuccess::SendTelegramMessage)
        .to have_received(:call)
        .with(reply_data: reply_data, request: button_request)

      expect(button_request.reload.status).to eq("COMPLETED")
      expect(button_request.prompt).to eq(extended_prompt)
    end
  end
end
