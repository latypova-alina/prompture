require "rails_helper"

describe Moderation::ResponseParser do
  subject(:parser) { described_class.new(response) }

  describe "#violence_score" do
    context "when value is present" do
      let(:response) { { "results" => [{ "category_scores" => { "violence" => 0.75 } }] } }

      it { expect(parser.violence_score).to eq(0.75) }
    end

    context "when value is missing" do
      let(:response) { { "results" => [{}] } }

      it { expect(parser.violence_score).to eq(0.0) }
    end
  end

  describe "#violence_graphic_score" do
    context "when value is present" do
      let(:response) { { "results" => [{ "category_scores" => { "violence/graphic" => 0.42 } }] } }

      it { expect(parser.violence_graphic_score).to eq(0.42) }
    end

    context "when value is missing" do
      let(:response) { { "results" => [{}] } }

      it { expect(parser.violence_graphic_score).to eq(0.0) }
    end
  end

  describe "#sexual_score" do
    context "when value is present" do
      let(:response) { { "results" => [{ "category_scores" => { "sexual" => 0.81 } }] } }

      it { expect(parser.sexual_score).to eq(0.81) }
    end

    context "when value is missing" do
      let(:response) { { "results" => [{}] } }

      it { expect(parser.sexual_score).to eq(0.0) }
    end
  end

  describe "#hate_threatening_category" do
    context "when value is present" do
      let(:response) { { "results" => [{ "categories" => { "hate/threatening" => true } }] } }

      it { expect(parser.hate_threatening_category).to eq(true) }
    end

    context "when value is missing" do
      let(:response) { { "results" => [{}] } }

      it { expect(parser.hate_threatening_category).to be_nil }
    end
  end

  describe "#sexual_minors_category" do
    context "when value is present" do
      let(:response) { { "results" => [{ "categories" => { "sexual/minors" => true } }] } }

      it { expect(parser.sexual_minors_category).to eq(true) }
    end

    context "when value is missing" do
      let(:response) { { "results" => [{}] } }

      it { expect(parser.sexual_minors_category).to be_nil }
    end
  end
end
