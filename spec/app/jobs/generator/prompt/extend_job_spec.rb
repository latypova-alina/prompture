require "rails_helper"

describe Generator::Prompt::ExtendJob do
  let(:job) { described_class.new }

  let(:raw_prompt) { "make it longer" }
  let(:extended_prompt) { "make it longer but more creative" }
  let(:chat_id) { 99 }

  before do
    allow(Generator::Prompt::SuccessNotifierJob).to receive(:perform_async)
    allow(Generator::Prompt::ErrorNotifierJob).to receive(:perform_async)
  end

  subject { job.perform(raw_prompt, chat_id) }

  describe "#perform" do
    context "when the prompt extender succeeds" do
      before do
        extender = instance_double(
          Generator::PromptExtender,
          extended_prompt: extended_prompt
        )

        allow(Generator::PromptExtender).to receive(:new)
          .with(raw_prompt)
          .and_return(extender)
      end

      it "enqueues SuccessNotifierJob with the extended prompt" do
        subject

        expect(Generator::Prompt::SuccessNotifierJob).to have_received(:perform_async)
          .with(extended_prompt, chat_id)
      end

      it "does not enqueue ErrorNotifierJob" do
        subject

        expect(Generator::Prompt::ErrorNotifierJob)
          .not_to have_received(:perform_async)
      end
    end

    context "when the prompt extender raises ChatGpt::ResponseError" do
      before do
        allow(Generator::PromptExtender).to receive(:new)
          .with(raw_prompt)
          .and_raise(ChatGpt::ResponseError)
      end

      it "rescues and enqueues ErrorNotifierJob" do
        subject

        expect(Generator::Prompt::ErrorNotifierJob).to have_received(:perform_async)
          .with(chat_id)
      end

      it "does not enqueue SuccessNotifierJob" do
        subject

        expect(Generator::Prompt::SuccessNotifierJob)
          .not_to have_received(:perform_async)
      end
    end
  end
end
