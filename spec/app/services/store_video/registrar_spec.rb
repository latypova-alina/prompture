require "rails_helper"

describe StoreVideo::Registrar do
  subject(:call_registrar) { described_class.call(record:, video_url:) }

  let(:video_url) { "https://internal.example/videos/motivation/cry/clip.mp4" }
  let(:command_request) { create(:command_prompt_to_video_request, :motivation) }
  let(:prompt_message) do
    create(:prompt_message, command_request:, parent_request: command_request, subcategory: "cry",
                            prompt: "Tears in rain")
  end
  let(:parent_request) { create(:button_image_processing_request, command_request:, parent_request: prompt_message) }
  let(:record) { create(:button_video_processing_request, command_request:, parent_request:) }

  it "creates stored video with category and subcategory" do
    expect { call_registrar }.to change(StoredVideo, :count).by(1)

    stored_video = StoredVideo.last
    expect(stored_video.video_url).to eq(video_url)
    expect(stored_video.category).to eq(ContentCategory::MOTIVATION)
    expect(stored_video.subcategory).to eq("cry")
    expect(stored_video.prompt).to eq("Tears in rain")
    expect(stored_video.source).to eq(record)
  end

  context "when subcategory is missing" do
    let(:prompt_message) do
      create(:prompt_message, command_request:, parent_request: command_request, subcategory: nil,
                              prompt: "Tears in rain")
    end

    it "does not create stored video" do
      expect { call_registrar }.not_to change(StoredVideo, :count)
    end
  end

  context "when category is not storable" do
    let(:command_request) { create(:command_prompt_to_video_request, category: nil) }

    it "does not create stored video" do
      expect { call_registrar }.not_to change(StoredVideo, :count)
    end
  end
end
