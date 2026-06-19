require "rails_helper"

describe MediaGenerator::SendReply do
  subject(:result) { described_class.call(params:) }

  let(:params) { { some: "params" } }
  let(:generated) { ["generated_media_url"] }

  let(:context_double) do
    instance_double(
      Generator::Media::FalVideoTaskRetrieverContext,
      status: status,
      processor: processor,
      button_request_id: button_request_id,
      task_id: task_id,
      generated:
    )
  end

  let(:processor) { "kling_2_1_pro_image_to_video" }
  let(:button_request_id) { 123 }
  let(:task_id) { "abc-123" }

  before do
    allow(Generator::Media::TaskRetrieverContext)
      .to receive(:for)
      .with(params:)
      .and_return(context_double)

    allow(Generator::Media::CompletedGenerationDispatcher).to receive(:call)
    allow(Generator::Media::CancelledGenerationDispatcher).to receive(:call)
    allow(Generator::Media::Interim::WebhookMessageDeleter).to receive(:call)
  end

  describe "#call" do
    context "when status is IN_PROGRESS" do
      let(:status) { "IN_PROGRESS" }

      it "does nothing" do
        expect(Generator::Media::TaskRetrieverDispatcher).not_to receive(:call)
        expect(Generator::Media::ErrorNotifierDispatcher).not_to receive(:call)
        expect(Generator::Media::Interim::WebhookMessageDeleter).not_to receive(:call)

        result
      end
    end

    context "when status is COMPLETED" do
      let(:status) { "COMPLETED" }

      it "deletes interim message and delegates to CompletedGenerationDispatcher" do
        result

        expect(Generator::Media::Interim::WebhookMessageDeleter)
          .to have_received(:call)
          .with(processor:, button_request_id:)

        expect(Generator::Media::CompletedGenerationDispatcher)
          .to have_received(:call)
          .with(
            processor:,
            button_request_id:,
            generated:,
            task_id:
          )
      end
    end

    context "when status is FAILED" do
      let(:status) { "FAILED" }

      it "deletes interim message and calls ErrorNotifierDispatcher" do
        expect(Generator::Media::ErrorNotifierDispatcher)
          .to receive(:call)
          .with(
            processor: processor,
            button_request_id: button_request_id
          )

        result

        expect(Generator::Media::Interim::WebhookMessageDeleter)
          .to have_received(:call)
          .with(processor:, button_request_id:)
        expect(Generator::Media::CancelledGenerationDispatcher).not_to have_received(:call)
      end
    end

    context "when status is CANCELLED" do
      let(:status) { "CANCELLED" }

      it "deletes interim message and calls CancelledGenerationDispatcher" do
        expect(Generator::Media::ErrorNotifierDispatcher).not_to receive(:call)

        result

        expect(Generator::Media::Interim::WebhookMessageDeleter)
          .to have_received(:call)
          .with(processor:, button_request_id:)
        expect(Generator::Media::CancelledGenerationDispatcher)
          .to have_received(:call)
          .with(processor:, button_request_id:)
      end
    end
  end
end
