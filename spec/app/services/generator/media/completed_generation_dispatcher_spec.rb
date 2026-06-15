require "rails_helper"

describe Generator::Media::CompletedGenerationDispatcher do
  subject(:call_service) do
    described_class.call(
      processor:,
      button_request_id:,
      generated:,
      task_id:
    )
  end

  let(:processor) { "kling_2_1_pro_image_to_video" }
  let(:button_request_id) { 123 }
  let(:generated) { ["generated_media_url"] }
  let(:task_id) { "abc-123" }

  before do
    allow(Generator::Media::EmptyGenerationAlert).to receive(:call)
    allow(Generator::Media::Image::TaskRetrieverJob).to receive(:perform_async)
    allow(Generator::Media::Video::FalTaskRetrieverJob).to receive(:perform_async)
    allow(Generator::Media::TaskRetrieverDispatcher).to receive(:call)
  end

  context "when generated is empty" do
    let(:generated) { [] }

    it "calls EmptyGenerationAlert" do
      call_service

      expect(Generator::Media::EmptyGenerationAlert)
        .to have_received(:call)
        .with(processor:, button_request_id:)

      expect(Generator::Media::Video::FalTaskRetrieverJob).not_to have_received(:perform_async)
      expect(Generator::Media::TaskRetrieverDispatcher).not_to have_received(:call)
    end
  end

  context "when processor is a video processor" do
    it "enqueues FalTaskRetrieverJob with webhook media url" do
      call_service

      expect(Generator::Media::Video::FalTaskRetrieverJob)
        .to have_received(:perform_async)
        .with("generated_media_url", button_request_id, processor)

      expect(Generator::Media::TaskRetrieverDispatcher).not_to have_received(:call)
    end
  end

  Generator::Processors::IMAGE.each do |image_processor|
    context "when processor is #{image_processor}" do
      let(:processor) { image_processor }

      it "enqueues Image::TaskRetrieverJob with webhook media url" do
        call_service

        expect(Generator::Media::Image::TaskRetrieverJob)
          .to have_received(:perform_async)
          .with("generated_media_url", button_request_id, processor)

        expect(Generator::Media::TaskRetrieverDispatcher).not_to have_received(:call)
      end
    end
  end
end
