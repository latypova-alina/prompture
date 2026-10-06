require "rails_helper"

describe ChatEvents::OutgoingChat do
  subject { described_class.new(action:, body: body.with_indifferent_access).chat_id }

  let(:action) { "sendMessage" }
  let(:body) { { chat_id: 111 } }

  it { is_expected.to eq(111) }

  context "when chat_id is a channel username" do
    let(:body) { { chat_id: "@channel" } }

    it { is_expected.to be_nil }
  end

  context "when answering a callback query" do
    let(:action) { "answerCallbackQuery" }
    let(:body) { { callback_query_id: "cbq-1" } }

    before do
      create(:chat_event, kind: "callback_query", chat_id: 222, payload: { "callback_query_id" => "cbq-1" })
    end

    it { is_expected.to eq(222) }

    context "when the callback wasn't recorded" do
      let(:body) { { callback_query_id: "unknown" } }

      it { is_expected.to be_nil }
    end
  end
end
