require "rails_helper"

describe BuildMysticImage::BuildMysticImage do
  describe ".organized" do
    subject { described_class.organized }

    it { is_expected.to eq([BuildMysticImage::CreateTask, BuildMysticImage::CheckStatus]) }
  end
end
