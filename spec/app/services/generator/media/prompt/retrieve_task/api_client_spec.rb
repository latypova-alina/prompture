require "rails_helper"

describe Generator::Media::Prompt::RetrieveTask::ApiClient do
  subject(:api_response) { described_class.new(task_id, api_url).api_response }

  let(:task_id) { "123" }
  let(:api_url) { "https://api.example.com/tasks" }

  let(:connection_instance) { double }
  let(:faraday_client_instance) { double }

  before do
    allow(::Clients::Generator::Connection)
      .to receive(:new)
      .with(api_url)
      .and_return(faraday_client_instance)

    allow(faraday_client_instance)
      .to receive(:connection)
      .and_return(connection_instance)

    allow(connection_instance)
      .to receive(:get)
      .with("#{api_url}/#{task_id}")
  end

  describe "#api_response" do
    it "calls GET on the generator API with task id" do
      api_response

      expect(connection_instance)
        .to have_received(:get)
        .with("#{api_url}/#{task_id}")
    end
  end
end
