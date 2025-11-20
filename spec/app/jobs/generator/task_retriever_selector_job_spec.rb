require "rails_helper"

describe Generator::TaskRetrieverSelectorJob do
  let(:job) { described_class.new }

  let(:task_id) { "abc123" }
  let(:chat_id) { 456 }

  before do
    described_class::RETRIEVER_JOBS.each_value do |klass|
      allow(klass).to receive(:perform_async)
    end
  end

  describe "#perform" do
    context "for every known button_request" do
      it "dispatches to the correct retriever job" do
        described_class::RETRIEVER_JOBS.each do |button_request, klass|
          job.perform(task_id, button_request, chat_id)

          expect(klass).to have_received(:perform_async)
            .with(task_id, chat_id)
        end
      end
    end

    context "for unknown button_request" do
      it "does nothing" do
        unknown = "not_existing_button"

        job.perform(task_id, unknown, chat_id)

        described_class::RETRIEVER_JOBS.each_value do |klass|
          expect(klass).not_to have_received(:perform_async)
        end
      end
    end
  end
end
