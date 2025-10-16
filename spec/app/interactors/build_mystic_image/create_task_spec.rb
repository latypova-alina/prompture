require "rails_helper"

describe BuildMysticImage::CreateTask, type: :interactor do
  subject(:interactor) { described_class.call(prompt:) }

  let(:prompt) { "A cute white kitten in a hat" }
  let(:mystic_client) { instance_double(Clients::Mystic::TaskCreator, task_id: "task_12345") }

  before do
    allow(Clients::Mystic::TaskCreator).to receive(:new).with(prompt).and_return(mystic_client)
  end

  describe "#call" do
    it "creates a mystic client with the prompt" do
      interactor
      expect(Clients::Mystic::TaskCreator).to have_received(:new).with(prompt)
    end

    it "sets context.task_id to the mystic client's task_id" do
      expect(interactor).to be_a_success
      expect(interactor.task_id).to eq("task_12345")
    end
  end
end
