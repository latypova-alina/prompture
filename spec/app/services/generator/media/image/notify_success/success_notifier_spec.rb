require "rails_helper"

describe Generator::Media::Image::NotifySuccess::SuccessNotifier do
  subject(:call_service) do
    described_class.call(image_url:, button_request_id: button_request.id)
  end

  let(:image_url) { "http://example.com/image.png" }
  let(:balance) { 7 }

  let(:button_request) do
    create(:button_image_processing_request, status: "PROCESSING").tap do |request|
      request.command_request.user.balance.update!(credits: balance)
    end
  end

  let(:presenter_selector_instance) { double }
  let(:presenter_instance) { double }
  let(:reply_data) { { text: "done" } }

  before do
    allow(Generator::Media::Image::NotifySuccess::PresenterSelector)
      .to receive(:new)
      .with(image_url:, request: button_request, balance:)
      .and_return(presenter_selector_instance)

    allow(presenter_selector_instance)
      .to receive(:presenter)
      .and_return(presenter_instance)

    allow(presenter_instance)
      .to receive(:reply_data)
      .and_return(reply_data)

    allow(Generator::Media::Image::NotifySuccess::SendTelegramMessage)
      .to receive(:call)
  end

  describe ".call" do
    it "sends telegram message and updates request status" do
      call_service

      expect(Generator::Media::Image::NotifySuccess::SendTelegramMessage)
        .to have_received(:call)
        .with(reply_data: reply_data, request: button_request)

      expect(button_request.reload.status).to eq("COMPLETED")
      expect(button_request.image_url).to eq(image_url)
    end
  end
end
