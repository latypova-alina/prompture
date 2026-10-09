require "rails_helper"

describe Moderation::Decision do
  subject { described_class.new(Moderation::ResponseParser.new(response)).blocked_by }

  let(:categories) { {} }
  let(:scores) { {} }
  let(:response) do
    { "results" => [{ "flagged" => false, "categories" => categories, "category_scores" => scores }] }
  end

  context "when nothing fires" do
    let(:scores) { { "violence" => 0.7, "violence/graphic" => 0.4, "sexual" => 0.8, "harassment" => 0.99 } }

    it { is_expected.to be_nil }
  end

  context "when sexual/minors is flagged" do
    let(:categories) { { "sexual/minors" => true } }

    it { is_expected.to eq("sexual_minors_category") }
  end

  context "when hate/threatening is flagged" do
    let(:categories) { { "hate/threatening" => true } }

    it { is_expected.to eq("hate_threatening_category") }
  end

  context "when violence is above its threshold" do
    let(:scores) { { "violence" => 0.71 } }

    it { is_expected.to eq("violence_score") }
  end

  context "when violence/graphic is above its threshold" do
    let(:scores) { { "violence/graphic" => 0.41 } }

    it { is_expected.to eq("violence_graphic_score") }
  end

  context "when sexual is above its threshold" do
    let(:scores) { { "sexual" => 0.81 } }

    it { is_expected.to eq("sexual_score") }
  end

  context "when several rules fire" do
    let(:categories) { { "hate/threatening" => true } }
    let(:scores) { { "violence" => 0.9 } }

    it { is_expected.to eq("hate_threatening_category") }
  end

  describe "#blocked?" do
    subject { described_class.new(Moderation::ResponseParser.new(response)).blocked? }

    let(:scores) { { "sexual" => 0.81 } }

    it { is_expected.to be(true) }
  end
end
