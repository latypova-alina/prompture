require "rails_helper"

describe ChatEvents::OutgoingPayload do
  subject { described_class.new(body:, message_ids:, error:).to_h }

  let(:body) { { "chat_id" => 1, "text" => "hi", "parse_mode" => "HTML", "secret_field" => "drop me" } }
  let(:message_ids) { [5] }
  let(:error) { nil }

  it { is_expected.to eq("parse_mode" => "HTML") }

  context "with an uploaded file" do
    let(:body) { { "photo" => StringIO.new("bytes") } }

    it { is_expected.to eq("photo" => "(upload)") }
  end

  context "with a media group" do
    let(:body) { { "media" => [{ type: "photo", media: "https://example.com/a.png", has_spoiler: true }] } }
    let(:message_ids) { [5, 6] }

    it do
      is_expected.to eq("media" => [{ "type" => "photo", "media" => "https://example.com/a.png" }],
                        "message_ids" => [5, 6])
    end
  end

  context "when the call failed" do
    let(:error) { Telegram::Bot::Forbidden.new("bot was blocked") }

    it { is_expected.to include("error" => { "class" => "Telegram::Bot::Forbidden", "message" => "bot was blocked" }) }
  end
end
