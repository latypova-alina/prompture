require "rails_helper"

describe Generator::Media::FalStatusResolver do
  subject(:resolver) { described_class.new(request) }

  let(:request) { create(:button_video_processing_request, fal_request_id: "req-123") }
  let(:client) { instance_double(Generator::Media::FalRequestClient) }

  before do
    allow(Generator::Media::FalRequestClient).to receive(:new).with(request).and_return(client)
  end

  describe "#status_text" do
    context "when fal status is IN_QUEUE" do
      before { allow(client).to receive(:status).and_return("IN_QUEUE") }

      it "returns in progress message" do
        expect(resolver.status_text).to eq(I18n.t("errors.generation_status_in_progress"))
      end
    end

    context "when fal status is IN_PROGRESS" do
      before { allow(client).to receive(:status).and_return("IN_PROGRESS") }

      it "returns in progress message" do
        expect(resolver.status_text).to eq(I18n.t("errors.generation_status_in_progress"))
      end
    end

    context "when fal status is COMPLETED" do
      before { allow(client).to receive(:status).and_return("COMPLETED") }

      it "returns completed message" do
        expect(resolver.status_text).to eq(I18n.t("errors.generation_status_completed"))
      end
    end

    context "when fal status is FAILED" do
      before { allow(client).to receive(:status).and_return("FAILED") }

      it "returns failed message" do
        expect(resolver.status_text).to eq(I18n.t("errors.generation_status_failed"))
      end
    end

    context "when fal status is unknown" do
      before { allow(client).to receive(:status).and_return("WEIRD") }

      it "returns unknown message" do
        expect(resolver.status_text).to eq(I18n.t("errors.generation_status_unknown"))
      end
    end

    context "when fal api call fails" do
      before { allow(client).to receive(:status).and_raise(StandardError) }

      it "returns unknown message" do
        expect(resolver.status_text).to eq(I18n.t("errors.generation_status_unknown"))
      end
    end
  end
end
