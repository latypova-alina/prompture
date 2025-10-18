require "rails_helper"

describe Clients::ImageGenerator::GeminiTaskCreator do
  let(:prompt) { "little kitten goes to school" }
  let(:task_creator) { described_class.new(prompt) }

  describe "#task_id" do
    it "returns the task_id from the response" do
      VCR.use_cassette("gemini_task_creator_success") do
        expect(task_creator.task_id).to eq("14fc0c3d-4923-47bc-ae2c-b071542db9a2")
      end
    end

    context "when response is not success" do
      it "raises a Freepik::ResponseError" do
        VCR.use_cassette("gemini_task_creator_error") do
          expect { task_creator.task_id }.to raise_error(::Freepik::ResponseError)
        end
      end
    end
  end
end
