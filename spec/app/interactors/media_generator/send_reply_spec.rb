require "rails_helper"

describe MediaGenerator::SendReply do
  subject(:result) { described_class.call(params:) }

  let(:params) { { some: "params" } }

  let(:context_double) do
    instance_double(
      Generator::Media::TaskRetrieverContext,
      status: status,
      processor: processor,
      button_request_id: button_request_id,
      task_id: task_id
    )
  end

  let(:processor) { "mystic_image" }
  let(:button_request_id) { 123 }
  let(:task_id) { "abc-123" }

  before do
    allow(Generator::Media::TaskRetrieverContext)
      .to receive(:new)
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
            task_id: task_id,
            button_request_id: button_request_id,
            processor: processor
          )

        result
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
