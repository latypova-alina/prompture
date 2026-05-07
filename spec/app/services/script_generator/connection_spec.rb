require "rails_helper"

describe ScriptGenerator::Connection do
  describe ".call" do
    let(:connection) { instance_double(Faraday::Connection) }

    before do
      allow(Faraday).to receive(:new).and_return(connection)
    end

    it "builds faraday connection with script generator settings" do
      described_class.call

      expect(Faraday).to have_received(:new).with(
        url: ENV.fetch("SCRIPT_GENERATOR_API_URL"),
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{ENV.fetch('SCRIPT_GENERATOR_API_KEY')}"
        }
      )
    end
  end
end
