require "rails_helper"

describe BuildImage::BuildImage do
  describe ".organized" do
    subject { described_class.organized }

    it { is_expected.to eq([BuildImage::CreateTask, BuildImage::CheckStatus]) }
  end
end
