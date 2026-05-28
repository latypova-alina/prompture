require "rails_helper"

describe MediaGenerator::SendReply do
  subject(:result) { described_class.call(params:) }

  let(:params) { { some: "params" } }
  let(:generated) { ["generated_media_url"] }

  let(:context_double) do
    instance_double(
      Generator::Media::FreepikTaskRetrieverContext,
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
  end

  describe "#call" do
    context "when status is IN_PROGRESS" do
      let(:status) { "IN_PROGRESS" }

      it "does nothing" do
        expect(Generator::Media::TaskRetrieverDispatcher).not_to receive(:call)
        expect(Generator::Media::ErrorNotifierDispatcher).not_to receive(:call)

        result
      end
    end

    context "when status is COMPLETED" do
      let(:status) { "COMPLETED" }

      it "calls TaskRetrieverDispatcher with correct arguments" do
        expect(Generator::Media::TaskRetrieverDispatcher)
          .to receive(:call)
          .with(
            task_id:,
            button_request_id:,
            processor:
          )

        result
      end
    end

    Generator::Processors::IMAGE.each do |image_processor|
      context "when status is COMPLETED for #{image_processor}" do
        let(:status) { "COMPLETED" }
        let(:processor) { image_processor }

        it "enqueues TaskRetrieverJob with webhook image url" do
          expect(Generator::Media::Image::TaskRetrieverJob)
            .to receive(:perform_async)
            .with(
              "generated_media_url",
              button_request_id,
              processor
            )

          expect(Generator::Media::TaskRetrieverDispatcher).not_to receive(:call)

          result
        end
      end
    end

    context "when status is FAILED" do
      let(:status) { "FAILED" }

      it "calls ErrorNotifierDispatcher with correct arguments" do
        expect(Generator::Media::ErrorNotifierDispatcher)
          .to receive(:call)
          .with(
            processor: processor,
            button_request_id: button_request_id
          )

        result
      end
    end
  end
end
