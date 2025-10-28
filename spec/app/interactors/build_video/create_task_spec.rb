require "rails_helper"

describe BuildVideo::CreateTask, type: :interactor do
  let(:image_url) { "http://example.com/image.png" }
  let(:image_prompt) { "little kitten goes to school" }

  subject(:interactor) { described_class.call(image_url:, image_prompt:, processor_type:) }

  before { allow(task_creator_class).to receive(:new).with(image_url, image_prompt).and_return(client) }

  context "when processor_type is kling_2_1_pro_image_to_video" do
    let(:processor_type) { "kling_2_1_pro_image_to_video" }
    let(:task_creator_class) { Clients::Generator::Video::Kling::TaskCreator }

    it_behaves_like "video create task interactor"
  end
end
