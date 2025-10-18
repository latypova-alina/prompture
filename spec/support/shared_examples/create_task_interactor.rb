require "rails_helper"

shared_context "create task interactor" do
  let(:task_id)  { "task_12345" }
  let(:client) { instance_double(task_creator_class, task_id:) }

  describe "#call" do
    it "creates a mystic client with the prompt" do
      interactor
      expect(task_creator_class).to have_received(:new).with(prompt)
    end

    it "sets context.task_id to the mystic client's task_id" do
      expect(interactor).to be_a_success
      expect(interactor.task_id).to eq(task_id)
    end
  end
end
