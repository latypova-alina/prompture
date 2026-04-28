require "rails_helper"

describe Generator::Media::Video::NotifySuccess::SuccessNotifier do
  subject(:call_service) do
    described_class.call(video_url:, button_request_id: button_request.id)
  end

  let(:video_url) { "http://example.com/video.mp4" }
  let(:balance) { 11 }
  let(:user) { create(:user, :with_custom_balance, credits: balance) }
  let(:processor_name) { button_request.humanized_process_name }
  let(:processor) { button_request.processor }
  let(:locale) { user.locale }

  let(:button_request) do
    create(:button_video_processing_request, status: "PENDING", user:)
  end

  let(:presenter_instance) { double }
  let(:reply_data) { { text: "done" } }

  before do
    allow(MediaGenerator::ButtonRequestPresenters::VideoProcessedMessagePresenter)
      .to receive(:new)
      .with(message: video_url, balance: balance, locale:, processor_name:, processor:)
      .and_return(presenter_instance)

    allow(presenter_instance)
      .to receive(:reply_data)
      .and_return(reply_data)

    allow(Generator::Media::Video::NotifySuccess::SendTelegramMessage)
      .to receive(:call)
  end

  describe ".call" do
    it "sends telegram message and updates request status" do
      call_service

      expect(MediaGenerator::ButtonRequestPresenters::VideoProcessedMessagePresenter)
        .to have_received(:new)
        .with(message: video_url, balance: balance, locale:, processor_name:, processor:)

      expect(Generator::Media::Video::NotifySuccess::SendTelegramMessage)
        .to have_received(:call)
        .with(reply_data: reply_data, request: button_request)

      expect(button_request.reload.status).to eq("COMPLETED")
      expect(button_request.video_url).to eq(video_url)
    end
  end
end
