require "rails_helper"

describe Admin::RefSortKeys do
  describe ".for" do
    subject(:sort_key) { described_class.for(key, ButtonImageProcessingRequest) }

    let(:key) { "status" }

    it { is_expected.to be_a(Admin::RefSortKeys::Status) }
    it { expect(sort_key.expression.to_s).to eq('UPPER("button_image_processing_requests".status)') }

    context "when the key is a Ruby-derived value" do
      let(:key) { "type" }

      it { expect(sort_key.expression).to be_nil }
      it { expect(sort_key.value(nil, Time.current)).to eq("ButtonImageProcessingRequest") }
    end

    context "when the key is not whitelisted" do
      let(:key) { "bogus" }

      it { expect { sort_key }.to raise_error(KeyError) }
    end
  end
end
