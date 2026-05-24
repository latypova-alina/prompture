require "rails_helper"

describe HasOriginPrompt do
  describe "#origin_subcategory" do
    subject(:origin_subcategory) { record.origin_subcategory }

    let(:command_request) { create(:command_prompt_to_video_request, :motivation) }
    let(:prompt_message) do
      create(:prompt_message, command_request:, parent_request: command_request, subcategory: "cry")
    end
    let(:parent_request) { create(:button_image_processing_request, command_request:, parent_request: prompt_message) }
    let(:record) { create(:button_video_processing_request, command_request:, parent_request:) }

    it "resolves subcategory from prompt message in parent chain" do
      expect(origin_subcategory).to eq("cry")
    end

    context "when prompt message has no subcategory" do
      let(:prompt_message) do
        create(:prompt_message, command_request:, parent_request: command_request, subcategory: nil)
      end

      it { is_expected.to be_nil }
    end

    context "when record is prompt message with subcategory" do
      let(:record) { prompt_message }

      it { is_expected.to eq("cry") }
    end
  end
end
