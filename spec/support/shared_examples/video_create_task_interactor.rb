require "rails_helper"

shared_context "video create task interactor" do
  let(:task_id)  { "task_12345" }
  let(:client) { instance_double(task_creator_class, task_id:) }

  describe "#call" do
    it "creates client with the image_url" do
      interactor
      expect(task_creator_class).to have_received(:new).with(image_url)
    end

    it "sets context.task_id to client's task_id" do
      expect(interactor).to be_a_success
      expect(interactor.task_id).to eq(task_id)
    end
  end
end
