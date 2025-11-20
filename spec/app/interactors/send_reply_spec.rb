require "rails_helper"

describe SendReply do
  let(:token) { "encoded-token" }
  let(:chat_id) { 123 }
  let(:button_request) { "extend_prompt" }
  let(:task_id) { "task-42" }

  let(:params) do
    ActionController::Parameters.new(
      freepik_webhook: { status: status, task_id: task_id },
      button_request: button_request,
      token: token
    )
  end

  before do
    allow(Generator::TaskRetrieverSelectorJob).to receive(:perform_async)
    allow(Generator::ErrorNotifierJob).to receive(:perform_async)

    allow(ChatToken).to receive(:decode).with(token).and_return(chat_id)
  end

  subject(:interactor) { described_class.call(params:) }

  context "when status is IN_PROGRESS" do
    let(:status) { "IN_PROGRESS" }

    it "does not enqueue any jobs" do
      interactor

      expect(Generator::TaskRetrieverSelectorJob).not_to have_received(:perform_async)
      expect(Generator::ErrorNotifierJob).not_to have_received(:perform_async)
    end
  end

  context "when status is COMPLETED" do
    let(:status) { "COMPLETED" }

    it "enqueues TaskRetrieverSelectorJob" do
      interactor

      expect(Generator::TaskRetrieverSelectorJob).to have_received(:perform_async)
        .with(task_id, button_request, chat_id)
    end

    it "does not enqueue ErrorNotifierJob" do
      interactor

      expect(Generator::ErrorNotifierJob).not_to have_received(:perform_async)
    end
  end

  context "when status is FAILED" do
    let(:status) { "FAILED" }

    it "enqueues ErrorNotifierJob" do
      interactor

      expect(Generator::ErrorNotifierJob).to have_received(:perform_async)
        .with(button_request, chat_id)
    end

    it "does not enqueue TaskRetrieverSelectorJob" do
      interactor

      expect(Generator::TaskRetrieverSelectorJob).not_to have_received(:perform_async)
    end
  end
end
