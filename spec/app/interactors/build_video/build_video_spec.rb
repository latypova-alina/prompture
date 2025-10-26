require "rails_helper"

describe BuildVideo::BuildVideo do
  describe ".organized" do
    subject { described_class.organized }

    it { is_expected.to eq([BuildVideo::CreateTask, BuildVideo::CheckStatus]) }
  end
end
