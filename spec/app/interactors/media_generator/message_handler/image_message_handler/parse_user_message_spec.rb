require "rails_helper"

describe MediaGenerator::MessageHandler::ImageMessageHandler::ParseUserMessage do
  subject(:result) { described_class.call(user_message:) }

  let(:user_message) do
    {
      "chat" => { "id" => 12_345 },
      "text" => "hello",
      "photo" => photos
    }
  end
  let(:photos) do
    [
      { "file_id" => "small", "width" => 320, "height" => 240, "file_size" => 1000 },
      { "file_id" => "large", "width" => 1280, "height" => 720, "file_size" => 5000 }
    ]
  end
  let(:message_parser) do
    instance_double(MessageParser, message_text: "hello", picture_id: "large", chat_id: 12_345, image_url: nil)
  end

  before do
    allow(MessageParser).to receive(:new).with(user_message).and_return(message_parser)
  end

  describe "#call" do
    it "assigns parsed message fields to context" do
      expect(result.message_text).to eq("hello")
      expect(result.chat_id).to eq(12_345)
      expect(result.picture_id).to eq("large")
      expect(result.image_url).to be_nil
    end

    it "uses largest photo to set width, height, and size_bytes" do
      expect(result.width).to eq(1280)
      expect(result.height).to eq(720)
      expect(result.size_bytes).to eq(5000)
    end

    context "when photo array is missing" do
      let(:photos) { nil }

      it "sets width, height, and size_bytes to nil" do
        expect(result.width).to be_nil
        expect(result.height).to be_nil
        expect(result.size_bytes).to be_nil
      end
    end
  end
end
