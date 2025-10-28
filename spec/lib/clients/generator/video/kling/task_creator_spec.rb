require "rails_helper"

describe Clients::Generator::Video::Kling::TaskCreator do
  let(:image_url) { "https://cdn-magnific.freepik.com/imagen3_a35022aa-611a-40a1-a792-4562a4058aab_0.png?token=exp=1761444103~hmac=70070e0512fdd937b5195b51a108b8c95363d5979f2dfe18015e888fa18f2d6d&size=stable" }
  let(:task_creator) { described_class.new(image_url, nil) }

  describe "#task_id" do
    it "returns the task_id from the response" do
      VCR.use_cassette("kling_task_creator_success") do
        expect(task_creator.task_id).to eq("192e8a86-eabf-40ce-b92a-33c6b7c2173d")
      end
    end

    context "when response is not success" do
      it "raises a Freepik::ResponseError" do
        VCR.use_cassette("kling_task_creator_error") do
          expect { task_creator.task_id }.to raise_error(::Freepik::ResponseError)
        end
      end
    end
  end
end
