require "rails_helper"

describe ScriptGenerator::CartoonCharacterContext do
  subject(:cartoon_character_context) { described_class.new(chat_id:) }

  let(:chat_id) { 456 }
  let(:connection) { instance_double(Faraday::Connection) }
  let(:response) do
    instance_double(
      Faraday::Response,
      success?: true,
      body: { "character_description" => "A blue Baby with pigtails, wearing a bow." }
    )
  end

  before do
    allow(ScriptGenerator::Connection).to receive(:call).and_return(connection)
    allow(connection).to receive(:get).with("/cartoon_character").and_return(response)
  end

  describe "#character_description" do
    it "returns character description from response body" do
      expect(cartoon_character_context.character_description)
        .to eq("A blue Baby with pigtails, wearing a bow.")
    end

    context "when request fails with non-success status" do
      let(:response) { instance_double(Faraday::Response, success?: false, body: "service unavailable") }

      it "raises ScriptGeneratorRequestError" do
        expect { cartoon_character_context.character_description }
          .to raise_error(ScriptGeneratorRequestError)
      end
    end

    context "when character description is blank" do
      let(:response) do
        instance_double(Faraday::Response, success?: true, body: { "character_description" => "" })
      end

      it "raises ScriptGeneratorRequestError" do
        expect { cartoon_character_context.character_description }
          .to raise_error(ScriptGeneratorRequestError)
      end
    end

    context "when Faraday raises an error" do
      before do
        allow(connection).to receive(:get).with("/cartoon_character")
                                          .and_raise(Faraday::TimeoutError.new("timeout"))
      end

      it "raises ScriptGeneratorRequestError" do
        expect { cartoon_character_context.character_description }
          .to raise_error(ScriptGeneratorRequestError, "timeout")
      end
    end
  end
end
