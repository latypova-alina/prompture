require "rails_helper"

describe Generator::Media::Image::CreateTask::PayloadStrategyBase do
  subject(:strategy) { strategy_class.new(prompt) }

  let(:prompt) { "little kitten" }

  let(:strategy_class) do
    Class.new(described_class) do
      const_set(:API_URL, "https://queue.fal.run/fal-ai/example")

      private

      def payload_params
        { example_param: "value" }
      end
    end
  end

  describe "#payload" do
    it "merges prompt with payload params" do
      expect(strategy.payload).to eq(
        prompt:,
        example_param: "value"
      )
    end
  end

  describe "#api_url" do
    it "returns the API_URL constant" do
      expect(strategy.api_url).to eq("https://queue.fal.run/fal-ai/example")
    end
  end
end
