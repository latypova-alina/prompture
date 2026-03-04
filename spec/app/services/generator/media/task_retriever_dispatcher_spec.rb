require "rails_helper"

describe Generator::Media::TaskRetrieverDispatcher do
  subject(:call_service) do
    described_class.call(task_id:, button_request_id:, processor:)
  end

  let(:task_id) { "task_123" }
  let(:button_request_id) { 456 }

  before do
    allow(Generator::Media::Image::TaskRetrieverJob)
      .to receive(:perform_async)

    allow(Generator::Media::Video::TaskRetrieverJob)
      .to receive(:perform_async)
  end

  describe ".call" do
    context "when processor is an image processor" do
      let(:processor) { Generator::Processors::IMAGE.first }

      it "dispatches image task retriever job" do
        call_service

        expect(Generator::Media::Image::TaskRetrieverJob)
          .to have_received(:perform_async)
          .with(task_id, button_request_id, processor)

        expect(Generator::Media::Video::TaskRetrieverJob)
          .not_to have_received(:perform_async)
      end
    end

    context "when processor is a video processor" do
      let(:processor) { Generator::Processors::VIDEO.first }

      it "dispatches video task retriever job" do
        call_service

        expect(Generator::Media::Video::TaskRetrieverJob)
          .to have_received(:perform_async)
          .with(task_id, button_request_id, processor)

        expect(Generator::Media::Image::TaskRetrieverJob)
          .not_to have_received(:perform_async)
      end
    end

    context "when processor is unsupported" do
      let(:processor) { "unknown_processor" }

      it "does not enqueue any job" do
        call_service

        expect(Generator::Media::Image::TaskRetrieverJob)
          .not_to have_received(:perform_async)

        expect(Generator::Media::Video::TaskRetrieverJob)
          .not_to have_received(:perform_async)
      end
    end
  end
end
