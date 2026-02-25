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
    allow(Generator::TaskRetrieverDispatcher).to receive(:call)
    allow(Generator::ErrorNotifierDispatcher).to receive(:call)

    allow(ChatToken).to receive(:decode).with(token).and_return(chat_id)
  end

  subject(:interactor) { described_class.call(params:) }

  context "when status is IN_PROGRESS" do
    let(:status) { "IN_PROGRESS" }

    it "does not enqueue any jobs" do
      interactor

      expect(Generator::TaskRetrieverDispatcher).not_to have_received(:call)
      expect(Generator::ErrorNotifierDispatcher).not_to have_received(:call)
    end
  end

  context "when status is COMPLETED" do
    let(:status) { "COMPLETED" }

    it "calls TaskRetrieverDispatcher" do
      interactor

      expect(Generator::TaskRetrieverDispatcher).to have_received(:call)
        .with(task_id:, button_request:, request_id: nil, chat_id:)
    end

    it "does not call ErrorNotifierDispatcher" do
      interactor

      expect(Generator::ErrorNotifierDispatcher).not_to have_received(:call)
    end
  end

  context "when status is FAILED" do
    let(:status) { "FAILED" }

    it "calls ErrorNotifierDispatcher" do
      interactor

      expect(Generator::ErrorNotifierDispatcher).to have_received(:call)
        .with(button_request:, chat_id:)
    end

    it "does not call TaskRetrieverDispatcher" do
      interactor

      expect(Generator::TaskRetrieverDispatcher).not_to have_received(:call)
    end
  end
end
