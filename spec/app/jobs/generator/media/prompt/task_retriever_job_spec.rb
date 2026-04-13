require "rails_helper"

describe Generator::Media::Prompt::TaskRetrieverJob do
  subject(:perform_job) do
    described_class.new.perform(task_id, button_request_id, processor)
  end

  let(:task_id) { "abc-123" }
  let(:button_request_id) { 42 }
  let(:processor) { Generator::Processors::PROMPT_EXTENSION }

  let(:retriever_instance) do
    instance_double(Generator::Media::Prompt::RetrieveTask::TaskRetriever)
  end
  let(:stored_media) { instance_double(Generator::Media::StoredMedia::Retriever, internal_media_url: extended_prompt) }
  let(:extended_prompt) { "Extended prompt text" }

  before do
    allow(
      Generator::Media::Prompt::RetrieveTask::TaskRetriever
    ).to receive(:new)
      .with(task_id, processor)
      .and_return(retriever_instance)
    allow(Generator::Media::StoredMedia::Retriever)
      .to receive(:new)
      .with(media_url: extended_prompt, button_request_id:, processor:)
      .and_return(stored_media)
  end

  describe "#perform" do
    context "when retriever succeeds" do
      before do
        allow(retriever_instance).to receive(:media_url).and_return(extended_prompt)
        allow(
          Generator::Media::Prompt::SuccessNotifierJob
        ).to receive(:perform_async)
      end

      it "calls SuccessNotifierJob with correct arguments" do
        expect(
          Generator::Media::Prompt::SuccessNotifierJob
        ).to receive(:perform_async).with(extended_prompt, button_request_id)

        perform_job
      end

      it "does not call ErrorNotifierJob" do
        expect(
          Generator::Media::Prompt::ErrorNotifierJob
        ).not_to receive(:perform_async)

        perform_job
      end
    end

    context "when Freepik::ResponseError is raised" do
      before do
        allow(retriever_instance)
          .to receive(:media_url)
          .and_raise(Freepik::ResponseError)

        allow(
          Generator::Media::Prompt::ErrorNotifierJob
        ).to receive(:perform_async)
      end

      it "calls ErrorNotifierJob with correct arguments" do
        expect(
          Generator::Media::Prompt::ErrorNotifierJob
        ).to receive(:perform_async).with(button_request_id)

        perform_job
      end
    end

    context "when internal media storing fails" do
      before do
        allow(retriever_instance).to receive(:media_url).and_return(extended_prompt)
        allow(stored_media).to receive(:internal_media_url).and_raise(StandardError)
        allow(
          Generator::Media::Prompt::SuccessNotifierJob
        ).to receive(:perform_async)
      end

      it "falls back to generated media url and still notifies success" do
        expect(
          Generator::Media::Prompt::SuccessNotifierJob
        ).to receive(:perform_async).with(extended_prompt, button_request_id)

        perform_job
      end
    end
  end
end
