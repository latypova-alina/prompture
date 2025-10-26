require "rails_helper"

describe BuildVideo::CheckStatus do
  subject(:interactor) { described_class.call(task_id:, processor_type:) }

  context "when processor_type is mystic_image" do
    let(:processor_type) { "kling_2_1_pro_image_to_video" }
    let(:retriever_class) { Clients::Generator::Video::Kling::TaskRetriever }

    it_behaves_like "video check task interactor"
  end
end
