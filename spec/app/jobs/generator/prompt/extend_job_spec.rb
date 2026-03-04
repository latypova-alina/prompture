require "rails_helper"

describe Generator::Prompt::ExtendJob do
  subject(:perform_job) { described_class.new.perform(button_request.id) }

  let(:parent_prompt_text) { "Original prompt" }
  let(:extended_prompt_text) { "Extended prompt" }

  let(:parent_request) do
    create(:prompt_message, prompt: parent_prompt_text)
  end

  let(:button_request) do
    create(
      :button_extend_prompt_request,
      parent_request:
    )
  end

  let(:prompt_extender_instance) { instance_double(Generator::PromptExtender) }

  before do
    allow(Generator::PromptExtender)
      .to receive(:new)
      .with(parent_prompt_text)
      .and_return(prompt_extender_instance)
  end

  describe "#perform" do
    context "when extension succeeds" do
      before do
        allow(prompt_extender_instance)
          .to receive(:extended_prompt)
          .and_return(extended_prompt_text)

        allow(
          Generator::Prompt::SuccessNotifierJob
        ).to receive(:perform_async)
      end

      it "calls SuccessNotifierJob with extended prompt and id" do
        expect(
          Generator::Prompt::SuccessNotifierJob
        ).to receive(:perform_async).with(
          extended_prompt_text,
          button_request.id
        )

        perform_job
      end

      it "does not call ErrorNotifierJob" do
        expect(
          Generator::Prompt::ErrorNotifierJob
        ).not_to receive(:perform_async)

        perform_job
      end
    end

    context "when ChatGpt::ResponseError is raised" do
      before do
        allow(prompt_extender_instance)
          .to receive(:extended_prompt)
          .and_raise(ChatGpt::ResponseError)

        allow(
          Generator::Prompt::ErrorNotifierJob
        ).to receive(:perform_async)
      end

      it "calls ErrorNotifierJob with id" do
        expect(
          Generator::Prompt::ErrorNotifierJob
        ).to receive(:perform_async).with(button_request.id)

        perform_job
      end
    end
  end
end
