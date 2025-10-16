require "rails_helper"

describe Clients::Mystic::Connection do
  let(:url) { "https://api.freepik.com/v1/ai/mystic" }

  subject { described_class.new(url) }

  describe "#connection" do
    let(:connection) { subject.connection }

    it "returns a Faraday connection with the correct URL" do
      expect(connection.url_prefix.to_s).to eq(url)
    end

    it "sets the correct headers" do
      expect(connection.headers["Content-Type"]).to eq("application/json")
      expect(connection.headers["x-freepik-api-key"]).to eq("FREEPIK_API_KEY")
    end
  end
end
