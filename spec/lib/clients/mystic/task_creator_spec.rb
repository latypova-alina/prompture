require "rails_helper"

describe Clients::Mystic::TaskCreator, vcr: true do
  let(:prompt) { "little kitten goes to school" }
  let(:task_creator) { described_class.new(prompt) }

  describe "#task_id" do
    it "returns the task_id from the response" do
      VCR.use_cassette("mystic_task_creator_success") do
        expect(task_creator.task_id).to eq("12345")
      end
    end

    # context "when response is not success" do
    #   it "raises a Mystic::NoResponseError" do
    #     allow_any_instance_of(Faraday::Response).to receive(:success?).and_return(false)
    #     expect { task_creator.response_body }.to raise_error(::Mystic::NoResponseError)
    #   end
    # end
  end
end
