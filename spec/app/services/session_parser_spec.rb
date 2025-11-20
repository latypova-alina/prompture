require "rails_helper"

describe SessionParser do
  let(:parser) do
    described_class.new(
      raw_prompt,
      raw_image_url,
      raw_chat_id,
      raw_button_request
    )
  end

  let(:raw_prompt)         { :cute_cat }
  let(:raw_image_url)      { :url_value }
  let(:raw_chat_id)        { "123" }
  let(:raw_button_request) { :extend_prompt }

  describe "#image_prompt" do
    it "returns a string" do
      expect(parser.image_prompt).to eq("cute_cat")
    end
  end

  describe "#image_url" do
    it "returns a string" do
      expect(parser.image_url).to eq("url_value")
    end
  end

  describe "#chat_id" do
    it "returns an integer" do
      expect(parser.chat_id).to eq(123)
    end
  end

  describe "#button_request" do
    it "returns a string" do
      expect(parser.button_request).to eq("extend_prompt")
    end
  end
end
