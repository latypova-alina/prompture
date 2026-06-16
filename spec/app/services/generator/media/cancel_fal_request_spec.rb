require "rails_helper"

describe Generator::Media::CancelFalRequest do
  subject(:call_service) { described_class.new(request).call }

  let(:request) do
    create(
      :button_video_processing_request,
      status: "PENDING",
      interim_tg_message_id: 99_001
    )
  end

  let(:client) { instance_double(Generator::Media::FalRequestClient) }
  let(:response) { instance_double(Faraday::Response, success?: success) }

  before do
    allow(Generator::Media::FalRequestClient).to receive(:new).with(request).and_return(client)
    allow(client).to receive(:cancel).and_return(response)
    allow(TelegramIntegration::DeleteMessage).to receive(:call)
  end

  describe "#call" do
    context "when cancel succeeds" do
      let(:success) { true }

      it "marks request as cancelled and deletes interim message" do
        call_service

        expect(request.reload.status).to eq("CANCELLED")
        expect(TelegramIntegration::DeleteMessage)
          .to have_received(:call)
          .with(chat_id: request.chat_id, message_id: 99_001)
      end
    end

    context "when cancel fails" do
      let(:success) { false }

      it "does not update request or delete interim message" do
        call_service

        expect(request.reload.status).to eq("PENDING")
        expect(TelegramIntegration::DeleteMessage).not_to have_received(:call)
      end
    end
  end
end
