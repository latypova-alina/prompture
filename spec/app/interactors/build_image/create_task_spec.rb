require "rails_helper"

describe BuildImage::CreateTask, type: :interactor do
  let(:prompt) { "A cute white kitten in a hat" }

  subject(:interactor) { described_class.call(prompt:, processor_type:) }

  before { allow(task_creator_class).to receive(:new).with(prompt).and_return(client) }

  context "when processor_type is mystic_image" do
    let(:processor_type) { "mystic_image" }
    let(:task_creator_class) { Clients::Generator::Image::Mystic::TaskCreator }

    it_behaves_like "image create task interactor"
  end

  context "when processor_type is gemini_image" do
    let(:processor_type) { "gemini_image" }
    let(:task_creator_class) { Clients::Generator::Image::Gemini::TaskCreator }

    it_behaves_like "image create task interactor"
  end

  context "when processor_type is imagen_image" do
    let(:processor_type) { "imagen_image" }
    let(:task_creator_class) { Clients::Generator::Image::Imagen::TaskCreator }

    it_behaves_like "image create task interactor"
  end
end
