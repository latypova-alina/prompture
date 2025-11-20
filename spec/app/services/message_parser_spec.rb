require "rails_helper"

describe MessageParser do
  let(:message_hash) do
    {
      "text" => "Hello world",
      "chat" => { "id" => 456 }
    }
  end

  let(:parser) { described_class.new(message_hash) }

  describe "#message_text" do
    it "returns the text field from the message" do
      expect(parser.message_text).to eq("Hello world")
    end
  end

  describe "#chat_id" do
    it "returns the chat id from the message" do
      expect(parser.chat_id).to eq(456)
    end
  end
end
