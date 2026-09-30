require "rails_helper"

describe Admin::ButtonRequestTypeSelection do
  subject(:call) { described_class.call(filters:) }

  let(:filters) { Admin::ButtonRequestsQuery::Filters.new(type:, processor:) }
  let(:type) { nil }
  let(:processor) { nil }

  context "when no type is given" do
    it { is_expected.to eq(Admin::ButtonRequestTypes::ALL) }
  end

  context "when a known type is given" do
    let(:type) { "ButtonExtendPromptRequest" }

    it { is_expected.to contain_exactly(ButtonExtendPromptRequest) }
  end

  context "when an unknown type is given" do
    let(:type) { "NotARealType" }

    it "falls back to all types" do
      expect(call).to eq(Admin::ButtonRequestTypes::ALL)
    end
  end

  context "when a processor filter is given" do
    let(:processor) { "flux_image" }

    it "excludes types without a processor column" do
      expect(call).not_to include(ButtonExtendPromptRequest)
    end

    it "keeps types that have a processor column" do
      expect(call).to include(ButtonImageProcessingRequest)
    end
  end

  context "when both type and processor filters are given" do
    let(:type) { "ButtonExtendPromptRequest" }
    let(:processor) { "flux_image" }

    it "returns nothing, since that type has no processor column" do
      expect(call).to eq([])
    end
  end
end
