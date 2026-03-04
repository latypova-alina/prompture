# spec/jobs/generator/prompt/success_notifier_job_spec.rb

require "rails_helper"

describe Generator::Prompt::SuccessNotifierJob do
  subject(:perform_job) do
    described_class.new.perform(extended_prompt, button_request.id)
  end

  let(:extended_prompt) { "Extended prompt text" }

  let(:button_request) do
    create(
      :button_extend_prompt_request,
      status: "PENDING",
      prompt: nil
    )
  end

  let(:reply_data) { { text: "Some reply" } }

  let(:presenter_instance) { instance_double(MediaGenerator::ButtonRequestPresenters::ExtendedPromptMessagePresenter) }

  before do
    allow(MediaGenerator::ButtonRequestPresenters::ExtendedPromptMessagePresenter)
      .to receive(:new)
      .with(message: extended_prompt)
      .and_return(presenter_instance)

    allow(presenter_instance)
      .to receive(:reply_data)
      .and_return(reply_data)

    allow(TelegramIntegration::SendMessageWithButtons)
      .to receive(:call)
  end

  describe "#perform" do
    it "sends telegram message with reply data and request" do
      expect(TelegramIntegration::SendMessageWithButtons)
        .to receive(:call)
        .with(reply_data: reply_data, request: button_request)

      perform_job
    end

    it "updates request prompt and status" do
      expect { perform_job }
        .to change { button_request.reload.status }
        .from("PENDING")
        .to("COMPLETED")

      expect(button_request.reload.prompt).to eq(extended_prompt)
    end
  end
end
