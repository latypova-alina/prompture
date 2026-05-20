require "rails_helper"

describe Generator::Media::Audio::NotifySuccess::SuccessNotifier do
  subject(:call_service) do
    described_class.call(audio_url:, button_request_id: button_request.id)
  end

  let(:audio_url) { "http://example.com/audio.mp3" }
  let(:balance) { 7 }
  let(:user) { create(:user, :with_custom_balance, credits: balance) }

  let(:button_request) do
    create(:button_audio_processing_request, status: "PENDING", user:)
  end

  let(:presenter_instance) { double }
  let(:reply_data) { { text: "done" } }

  before do
    allow(MediaGenerator::ButtonRequestPresenters::AudioProcessedMessagePresenter)
      .to receive(:new)
      .and_return(presenter_instance)

    allow(presenter_instance)
      .to receive(:reply_data)
      .and_return(reply_data)

    allow(Generator::Media::Audio::NotifySuccess::SendTelegramMessage)
      .to receive(:call)
  end

  describe ".call" do
    it "sends telegram message and updates request status" do
      call_service

      expect(Generator::Media::Audio::NotifySuccess::SendTelegramMessage)
        .to have_received(:call)
        .with(reply_data: reply_data, request: button_request)

      expect(button_request.reload.status).to eq("COMPLETED")
      expect(button_request.audio_url).to eq(audio_url)
    end
  end
end
