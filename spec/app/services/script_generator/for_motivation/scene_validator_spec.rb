require "rails_helper"

describe ScriptGenerator::ForMotivation::SceneValidator do
  subject(:validator) { described_class.new(value) }

  describe "#valid?" do
    context "when value is a valid scene array" do
      let(:value) do
        [
          { "subcategory" => "cry", "text" => "A crying person sitting alone in the rain" },
          { "subcategory" => "Hope", "text" => "Person on a mountain at sunrise" }
        ]
      end

      it { is_expected.to be_valid }
    end

    context "when value is a string array" do
      let(:value) { ["A crying person sitting alone in the rain"] }

      it { is_expected.not_to be_valid }
    end

    context "when scene object is missing subcategory" do
      let(:value) { [{ "text" => "A crying person sitting alone in the rain" }] }

      it { is_expected.not_to be_valid }
    end

    context "when scene object is missing text" do
      let(:value) { [{ "subcategory" => "cry" }] }

      it { is_expected.not_to be_valid }
    end

    context "when value is not an array" do
      let(:value) { { "subcategory" => "cry", "text" => "Rain scene" } }

      it { is_expected.not_to be_valid }
    end
  end
end
