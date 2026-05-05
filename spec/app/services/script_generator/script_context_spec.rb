require "rails_helper"

describe ScriptGenerator::ScriptContext do
  subject(:script_context) { described_class.new(chat_id:) }

  let(:chat_id) { 456 }
  let(:result_context) { double("Interactor::Context", failure?: false, script_array: "scene one\n\nscene two") }

  before do
    allow(ScriptGenerator::GenerateScript).to receive(:call).with(chat_id:).and_return(result_context)
  end

  describe "#script_array" do
    it "delegates to successful GenerateScript result" do
      expect(script_context.script_array).to eq("scene one\n\nscene two")
    end

    context "when GenerateScript fails" do
      let(:error) { ScriptGeneratorRequestError.new("failed") }
      let(:result_context) { double("Interactor::Context", failure?: true, error:) }

      it "raises result error" do
        expect { script_context.script_array }.to raise_error(error)
      end
    end
  end
end
