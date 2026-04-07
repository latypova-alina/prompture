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

  describe "#image_url" do
    context "when message contains a url entity" do
      let(:message_hash) do
        {
          "text" => "Some text\n\nhttps://example.com/image.png",
          "chat" => { "id" => 456 },
          "entities" => [{ "offset" => 11, "length" => 29, "type" => "url" }]
        }
      end

      it "returns only the url value from message text" do
        expect(parser.image_url).to eq("https://example.com/image.png")
      end
    end

    context "when message does not contain a url entity" do
      it "returns nil" do
        expect(parser.image_url).to be_nil
      end
    end
  end
end
