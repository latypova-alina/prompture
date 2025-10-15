require "rails_helper"

describe Clients::Mystic::TaskCreator do
  let(:prompt) { "little kitten goes to school" }
  let(:task_creator) { described_class.new(prompt) }

  describe "#task_id" do
    it "returns the task_id from the response" do
      VCR.use_cassette("mystic_task_creator_success") do
        expect(task_creator.task_id).to eq("0a5f0976-011d-411e-abdf-8da8bd07ef9e")
      end
    end

    context "when response is not success" do
      it "raises a Mystic::ResponseError" do
        VCR.use_cassette("mystic_task_creator_error") do
          expect { task_creator.task_id }.to raise_error(::Mystic::ResponseError)
        end
      end
    end
  end
end
