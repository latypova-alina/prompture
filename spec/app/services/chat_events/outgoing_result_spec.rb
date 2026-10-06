require "rails_helper"

describe ChatEvents::OutgoingResult do
  subject { described_class.new(result).message_ids }

  let(:result) { { "ok" => true, "result" => { "message_id" => 5 } } }

  it { is_expected.to eq([5]) }

  context "when the call returned a media group" do
    let(:result) { { "ok" => true, "result" => [{ "message_id" => 5 }, { "message_id" => 6 }] } }

    it { is_expected.to eq([5, 6]) }
  end

  context "when the call returned no message (e.g. deleteMessage)" do
    let(:result) { { "ok" => true, "result" => true } }

    it { is_expected.to be_empty }
  end

  context "when the result isn't a Telegram response (e.g. the test stub)" do
    let(:result) { [{ chat_id: 1, text: "hi" }] }

    it { is_expected.to be_empty }
  end
end
