require "rails_helper"

describe Generator::Media::FalRequestClient do
  subject(:client) { described_class.new(request) }

  let(:request) do
    create(
      :button_video_processing_request,
      fal_request_id: "req-123",
      processor: "kling_2_1_pro_image_to_video"
    )
  end

  let(:connection) { instance_double(Faraday::Connection) }
  let(:status_response) { instance_double(Faraday::Response, body: '{"status":"IN_PROGRESS"}') }
  let(:cancel_response) { instance_double(Faraday::Response, success?: true) }

  before do
    allow(Clients::Generator::Connection::Fal)
      .to receive(:new)
      .and_return(instance_double(Clients::Generator::Connection::Fal, connection:))

    allow(connection).to receive_messages(get: status_response, put: cancel_response)
  end

  describe "#status" do
    it "fetches status from fal api" do
      expect(client.status).to eq("IN_PROGRESS")

      expect(connection).to have_received(:get).with(
        "https://queue.fal.run/fal-ai/kling-video/requests/req-123/status"
      )
    end
  end

  describe "#cancel_request" do
    it "sends cancel request to fal api" do
      client.cancel_request

      expect(connection).to have_received(:put).with(
        "https://queue.fal.run/fal-ai/kling-video/requests/req-123/cancel"
      )
    end

    context "when processor is veo3_1_lite_image_to_video" do
      let(:request) do
        create(
          :button_video_processing_request,
          fal_request_id: "req-123",
          processor: "veo3_1_lite_image_to_video"
        )
      end

      it "uses configured cancel base url" do
        client.cancel_request

        expect(connection).to have_received(:put).with(
          "https://queue.fal.run/fal-ai/veo3.1/requests/req-123/cancel"
        )
      end
    end
  end
end
