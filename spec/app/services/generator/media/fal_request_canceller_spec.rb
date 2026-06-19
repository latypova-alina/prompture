require "rails_helper"

describe Generator::Media::FalRequestCanceller do
  subject(:canceller) { described_class.new(request) }

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
    allow(client).to receive_messages(cancel_request: response, success?: success)
  end

  describe "#cancel_request" do
    context "when cancel succeeds" do
      let(:success) { true }

      it "sends cancel request without updating request state" do
        canceller.cancel_request

        expect(client).to have_received(:cancel_request)
        expect(request.reload.status).to eq("PENDING")
        expect(request.interim_tg_message_id).to eq(99_001)
        expect(canceller.success?).to be(true)
      end
    end

    context "when cancel fails" do
      let(:success) { false }

      it "does not update request" do
        canceller.cancel_request

        expect(request.reload.status).to eq("PENDING")
        expect(request.interim_tg_message_id).to eq(99_001)
        expect(canceller.success?).to be(false)
      end
    end
  end
end
