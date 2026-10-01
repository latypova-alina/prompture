require "rails_helper"

describe Admin::SortParams do
  subject { described_class.call(ActionController::Parameters.new(params), keys: %w[status created]) }

  let(:params) { { sort: "status", direction: "desc" } }

  it { is_expected.to have_attributes(key: "status", direction: "desc") }

  context "when no sort is given" do
    let(:params) { {} }

    it { is_expected.to eq(Admin::SortParams::DEFAULT) }
  end

  context "when the sort key is not whitelisted" do
    let(:params) { { sort: "id; DROP TABLE users", direction: "asc" } }

    it { is_expected.to eq(Admin::SortParams::DEFAULT) }
  end

  context "when the sort key is an array" do
    let(:params) { { sort: %w[status created] } }

    it { is_expected.to eq(Admin::SortParams::DEFAULT) }
  end

  context "when the direction is missing" do
    let(:params) { { sort: "status" } }

    it { is_expected.to have_attributes(key: "status", direction: "asc") }
  end

  context "when the direction is invalid for created" do
    let(:params) { { sort: "created", direction: "sideways" } }

    it { is_expected.to have_attributes(key: "created", direction: "desc") }
  end
end
