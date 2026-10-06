require "rails_helper"

describe Admin::ButtonRequestRelations do
  subject(:call) { described_class.call(user:, filters:) }

  let(:filters) { Admin::ButtonRequestsQuery::Filters.new(type:, date_from:) }
  let(:type) { nil }
  let(:date_from) { nil }

  let(:user) { create(:user, :with_balance) }
  let(:image_command) { create(:command_prompt_to_image_request, user:) }

  let!(:image_request) do
    create(:button_image_processing_request, :completed, command_request: image_command, created_at: 2.days.ago)
  end
  let!(:extend_prompt_request) do
    create(:button_extend_prompt_request, command_request: image_command, created_at: 1.day.ago)
  end

  it "returns a relation per button request type, scoped to the user" do
    expect(call.values.flat_map(&:to_a)).to contain_exactly(image_request, extend_prompt_request)
  end

  context "when filtering by type" do
    let(:type) { "ButtonExtendPromptRequest" }

    it { expect(call.keys).to eq([ButtonExtendPromptRequest]) }
  end

  context "when filtering by date range" do
    let(:date_from) { 1.day.ago.to_date.to_s }

    it { expect(call.values.flat_map(&:to_a)).to contain_exactly(extend_prompt_request) }
  end
end
