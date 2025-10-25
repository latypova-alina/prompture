require "rails_helper"

describe BuildImage::CheckStatus do
  subject(:interactor) { described_class.call(task_id:, processor_type:) }

  context "when processor_type is mystic_image" do
    let(:processor_type) { "mystic_image" }
    let(:retriever_class) { Clients::Generator::Image::Mystic::TaskRetriever }

    it_behaves_like "check task interactor"
  end

  context "when processor_type is gemini_image" do
    let(:processor_type) { "gemini_image" }
    let(:retriever_class) { Clients::Generator::Image::Gemini::TaskRetriever }

    it_behaves_like "check task interactor"
  end

  context "when processor_type is imagen_image" do
    let(:processor_type) { "imagen_image" }
    let(:retriever_class) { Clients::Generator::Image::Imagen::TaskRetriever }

    it_behaves_like "check task interactor"
  end
end
