require "rails_helper"

describe Generator::Media::Prompt::SuccessNotifierJob do
  subject(:perform_job) do
    described_class.new.perform(extended_prompt, button_request_id)
  end

  let(:extended_prompt) { "Extended prompt text" }
  let(:button_request_id) { 123 }

  before do
    allow(
      Generator::Media::Prompt::NotifySuccess::SuccessNotifier
    ).to receive(:call)
  end

  it "calls SuccessNotifier with correct arguments" do
    expect(
      Generator::Media::Prompt::NotifySuccess::SuccessNotifier
    ).to receive(:call).with(extended_prompt:, button_request_id:)

    perform_job
  end
end
