require "rails_helper"

describe ScriptGenerator::SendRandomCharacterJob do
  describe "#perform" do
    let(:connection) { instance_double(Faraday::Connection) }

    before do
      allow(Faraday).to receive(:new).and_return(connection)
      allow(Telegram.bot).to receive(:send_message)
    end

    context "when API request succeeds" do
      let(:response) do
        instance_double(
          Faraday::Response,
          success?: true,
          body: { "character_description" => "A cheerful robot baker" }
        )
      end

      before do
        allow(connection).to receive(:get).with("/random_character").and_return(response)
      end

      it "sends character description to chat" do
        described_class.new.perform(456)

        expect(Telegram.bot).to have_received(:send_message).with(
          chat_id: 456,
          text: "A cheerful robot baker"
        )
      end
    end

    context "when API request fails" do
      let(:response) { instance_double(Faraday::Response, success?: false) }

      before do
        allow(connection).to receive(:get).with("/random_character").and_return(response)
      end

      it "sends script generator error message" do
        described_class.new.perform(456)

        expect(Telegram.bot).to have_received(:send_message).with(
          chat_id: 456,
          text: I18n.t("errors.script_generator_request_failed")
        )
      end
    end

    context "when API request raises Faraday error" do
      before do
        allow(connection).to receive(:get).with("/random_character").and_raise(Faraday::TimeoutError.new("timeout"))
      end

      it "sends script generator error message" do
        described_class.new.perform(456)

        expect(Telegram.bot).to have_received(:send_message).with(
          chat_id: 456,
          text: I18n.t("errors.script_generator_request_failed")
        )
      end
    end
  end
end
