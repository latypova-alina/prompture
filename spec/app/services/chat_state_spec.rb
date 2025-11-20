require "rails_helper"

describe ChatState do
  let(:redis) { double("redis", set: true, get: "value", del: true) }

  before { allow(Sidekiq).to receive(:redis).and_yield(redis) }

  let(:chat_id) { 123 }
  let(:key)     { :last_image_url }
  let(:value)   { "https://example.com/img.png" }

  describe ".set" do
    it "stores a value in redis under the formatted key" do
      expect(redis).to receive(:set)
        .with("chat:123:last_image_url", value)

      ChatState.set(chat_id, key, value)
    end
  end

  describe ".get" do
    it "fetches a value from redis using the formatted key" do
      expect(redis).to receive(:get)
        .with("chat:123:last_image_url")
        .and_return(value)

      result = ChatState.get(chat_id, key)
      expect(result).to eq(value)
    end
  end

  describe ".del" do
    it "deletes the redis key" do
      expect(redis).to receive(:del)
        .with("chat:123:last_image_url")

      ChatState.del(chat_id, key)
    end
  end
end
