require "rails_helper"

describe Generator::Media::Video::CreateTask::ApiClient do
  subject(:client) { described_class.new(api_url, payload) }

  let(:api_url) { "https://example.com" }
  let(:payload) { { foo: "bar" } }

  let(:connection_instance) { instance_double(Clients::Generator::Connection) }
  let(:faraday_connection) { double }

  let(:response_double) { double }

  before do
    allow(Clients::Generator::Connection)
      .to receive(:new)
      .with(api_url)
      .and_return(connection_instance)

    allow(connection_instance)
      .to receive(:connection)
      .and_return(faraday_connection)

    allow(faraday_connection)
      .to receive(:post)
      .and_yield(double.as_null_object)
      .and_return(response_double)
  end

  describe "#response" do
    it "creates a connection with api_url" do
      client.response

      expect(Clients::Generator::Connection)
        .to have_received(:new)
        .with(api_url)
    end

    it "posts payload as JSON body" do
      request_double = double
      expect(request_double).to receive(:body=).with(payload.to_json)

      allow(faraday_connection)
        .to receive(:post)
        .and_yield(request_double)
        .and_return(response_double)

      client.response
    end

    it "returns the response" do
      allow(faraday_connection)
        .to receive(:post)
        .and_return(response_double)

      expect(client.response).to eq(response_double)
    end
  end
end
