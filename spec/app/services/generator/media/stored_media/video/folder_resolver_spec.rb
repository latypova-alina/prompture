require "rails_helper"

describe Generator::Media::StoredMedia::Video::FolderResolver do
  subject(:folder) { described_class.new(record:).folder }

  let(:command_request) { create(:command_prompt_to_video_request, :motivation) }
  let(:prompt_message) do
    create(:prompt_message, command_request:, parent_request: command_request, subcategory: "cry")
  end
  let(:parent_request) { create(:button_image_processing_request, command_request:, parent_request: prompt_message) }
  let(:record) { create(:button_video_processing_request, command_request:, parent_request:) }

  it { is_expected.to eq("videos/motivation/cry") }

  context "when subcategory is missing" do
    let(:prompt_message) do
      create(:prompt_message, command_request:, parent_request: command_request, subcategory: nil)
    end

    it { is_expected.to eq("videos/motivation") }
  end
end
