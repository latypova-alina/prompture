require "rails_helper"

describe Generator::Media::Image::CreateTask::FluxApiClient do
  subject(:client) { described_class.new(api_url, payload) }

  let(:api_url) { "https://queue.fal.run/fal-ai/flux/dev" }
  let(:payload) { { prompt: "hello", fal_webhook: webhook_url } }
  let(:webhook_url) { "https://example.com/api/fal/webhook?processor=flux_image" }

  let(:connection_instance) { instance_double(Clients::Generator::Connection::Fal) }
  let(:faraday_connection) { double }
  let(:response_double) { double }

  before do
    allow(Clients::Generator::Connection::Fal)
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

  it "sends webhook in query and prompt in body" do
    request_double = double
    expect(request_double).to receive(:url)
      .with("#{api_url}?fal_webhook=#{CGI.escape(webhook_url)}")
    expect(request_double).to receive(:body=).with({ prompt: "hello" }.to_json)

    allow(faraday_connection)
      .to receive(:post)
      .and_yield(request_double)
      .and_return(response_double)

    client.response
  end
end
