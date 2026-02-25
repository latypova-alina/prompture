require "rails_helper"

describe Generator::TaskRetrieverDispatcher do
  let(:task_id) { "abc123" }
  let(:chat_id) { 456 }
  let(:request_id) { 789 }

  before do
    described_class::RETRIEVER_JOBS.each_value do |klass|
      allow(klass).to receive(:perform_async)
    end
  end

  describe ".call" do
    context "for every known button_request" do
      it "dispatches to the correct retriever job" do
        described_class::RETRIEVER_JOBS.each do |button_request, klass|
          described_class.call(
            task_id: task_id,
            button_request: button_request,
            request_id: request_id,
            chat_id: chat_id
          )

          expect(klass).to have_received(:perform_async)
            .with(task_id, chat_id, request_id)
        end
      end
    end

    context "for unknown button_request" do
      it "does nothing" do
        described_class.call(
          task_id: task_id,
          button_request: "not_existing_button",
          request_id: request_id,
          chat_id: chat_id
        )

        described_class::RETRIEVER_JOBS.each_value do |klass|
          expect(klass).not_to have_received(:perform_async)
        end
      end
    end
  end
end
