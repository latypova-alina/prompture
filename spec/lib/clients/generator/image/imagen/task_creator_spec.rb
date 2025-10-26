require "rails_helper"

describe Clients::Generator::Image::Imagen::TaskCreator do
  let(:prompt) { "little kitten goes to school" }
  let(:task_creator) { described_class.new(prompt) }

  describe "#task_id" do
    it "returns the task_id from the response" do
      VCR.use_cassette("imagen_task_creator_success") do
        expect(task_creator.task_id).to eq("a35022aa-611a-40a1-a792-4562a4058aab")
      end
    end

    context "when response is not success" do
      it "raises a Freepik::ResponseError" do
        VCR.use_cassette("imagen_task_creator_error") do
          expect { task_creator.task_id }.to raise_error(::Freepik::ResponseError)
        end
      end
    end
  end
end
