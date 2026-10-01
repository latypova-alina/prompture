require "rails_helper"

describe Admin::ButtonRequestsQuery do
  subject(:call) { described_class.call(user:, filters:, page:) }

  let(:filters) { Admin::ButtonRequestsQuery::Filters.new(status:) }
  let(:status) { nil }
  let(:page) { 1 }

  let(:user) { create(:user, :with_balance) }
  let(:image_command) { create(:command_prompt_to_image_request, user:) }

  let!(:image_request) do
    create(:button_image_processing_request, :completed, command_request: image_command, created_at: 2.days.ago)
  end
  let!(:extend_prompt_request) do
    create(:button_extend_prompt_request, command_request: image_command, created_at: 1.day.ago)
  end

  it "returns hydrated button requests across types, most recent first" do
    expect(call.records).to eq([extend_prompt_request, image_request])
  end

  context "when filtering by status" do
    let(:status) { "COMPLETED" }

    it { expect(call.records).to contain_exactly(image_request) }
  end

  context "when there are more than 20 matching button requests" do
    before { create_list(:button_image_processing_request, 20, :completed, command_request: image_command) }

    it { expect(call.records.size).to eq(20) }

    context "on the second page" do
      let(:page) { 2 }

      it { expect(call.records.size).to eq(2) }
    end
  end

  describe ".count" do
    subject { described_class.count(user:, filters:) }

    it { is_expected.to eq(2) }

    context "when filtering by status" do
      let(:status) { "COMPLETED" }

      it { is_expected.to eq(1) }
    end
  end
end
