require "rails_helper"

describe Reviews::AnswersValidator do
  subject(:validator) { described_class.new(answers:) }

  let(:answers) do
    {
      "rating" => 4,
      "use_cases" => { "selected" => %w[fun] },
      "features" => { "selected" => %w[video] },
      "missing" => "longer videos and more voices",
      "frustrations" => "generation is sometimes too slow"
    }
  end

  describe "#errors" do
    subject { validator.errors }

    it { is_expected.to be_empty }

    context "when answers are not a hash" do
      let(:answers) { "nope" }

      it { is_expected.to include("rating" => :required, "missing" => :required) }
    end

    context "with a rating" do
      [nil, 0, 6, "5", 4.5].each do |rating|
        context "of #{rating.inspect}" do
          let(:answers) { super().merge("rating" => rating) }

          it { is_expected.to eq("rating" => :required) }
        end
      end
    end

    context "with a text answer" do
      context "when blank" do
        let(:answers) { super().merge("missing" => "   ") }

        it { is_expected.to eq("missing" => :required) }
      end

      context "when shorter than 10 characters after trimming" do
        let(:answers) { super().merge("missing" => "  more vids   ") }

        it { is_expected.to eq("missing" => :too_short) }
      end

      context "when exactly 10 characters" do
        let(:answers) { super().merge("missing" => "more vids!") }

        it { is_expected.to be_empty }
      end

      context "when longer than the maximum" do
        let(:answers) { super().merge("missing" => "a" * 2001) }

        it { is_expected.to eq("missing" => :too_long) }
      end

      context "when not a string" do
        let(:answers) { super().merge("missing" => { "text" => "x" * 30 }) }

        it { is_expected.to eq("missing" => :required) }
      end
    end

    context "with a multi choice answer" do
      context "when nothing is selected" do
        let(:answers) { super().merge("features" => { "selected" => [] }) }

        it { is_expected.to eq("features" => :required) }
      end

      context "when an option isn't in the survey" do
        let(:answers) { super().merge("features" => { "selected" => %w[video teleportation] }) }

        it { is_expected.to eq("features" => :invalid_option) }
      end

      context "when choosing other on a question without it" do
        let(:answers) { super().merge("features" => { "selected" => %w[other], "other" => "x" * 30 }) }

        it { is_expected.to eq("features" => :invalid_option) }
      end

      context "when other is selected with a short text" do
        let(:answers) { super().merge("use_cases" => { "selected" => %w[other], "other" => "memes" }) }

        it { is_expected.to eq("use_cases" => :other_too_short) }
      end

      context "when other is selected with enough text" do
        let(:answers) do
          super().merge("use_cases" => { "selected" => %w[other], "other" => "making memes for my friends" })
        end

        it { is_expected.to be_empty }
      end
    end
  end

  describe "#normalized_answers" do
    subject { validator.normalized_answers }

    let(:answers) do
      super().merge("missing" => "  longer videos and more voices  ", "evil" => "drop me",
                    "use_cases" => { "selected" => %w[fun fun], "other" => "ignored without other", "x" => 1 })
    end

    it {
      is_expected.to eq(answers.except("evil").merge("missing" => "longer videos and more voices",
                                                     "use_cases" => { "selected" => %w[fun] }))
    }
  end
end
