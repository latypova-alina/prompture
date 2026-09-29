require "rails_helper"

describe Admin::ButtonRequestsQuery do
  subject(:call) { described_class.call(user:, type:, date_from:, date_to:, page:) }

  let(:user) { create(:user, :with_balance) }
  let(:type) { nil }
  let(:date_from) { nil }
  let(:date_to) { nil }
  let(:page) { 1 }

  let(:image_command) { create(:command_prompt_to_image_request, user:) }
  let(:audio_command) { create(:command_prompt_to_audio_request, user:) }

  let!(:image_request) do
    create(:button_image_processing_request, :completed, command_request: image_command, created_at: 2.days.ago)
  end
  let!(:extend_prompt_request) do
    create(:button_extend_prompt_request, command_request: image_command, created_at: 1.day.ago)
  end

  it "returns all of the user's button requests across command types, most recent first" do
    expect(call.records).to eq([extend_prompt_request, image_request])
  end

  it "does not include another user's button requests" do
    other_user = create(:user, :with_balance)
    other_command = create(:command_prompt_to_image_request, user: other_user)
    create(:button_image_processing_request, :completed, command_request: other_command)

    expect(call.records).to contain_exactly(image_request, extend_prompt_request)
  end

  context "when filtering by type" do
    let(:type) { "ButtonExtendPromptRequest" }

    it { expect(call.records).to contain_exactly(extend_prompt_request) }
  end

  context "when filtering by date range" do
    let(:date_from) { 1.5.days.ago.to_date.to_s }

    it { expect(call.records).to contain_exactly(extend_prompt_request) }
  end

  context "when there are more than 20 matching button requests" do
    before { create_list(:button_image_processing_request, 20, :completed, command_request: image_command) }

    it "paginates to 20 records on the first page" do
      expect(call.records.size).to eq(20)
    end

    context "on the second page" do
      let(:page) { 2 }

      it { expect(call.records.size).to eq(2) }
    end
  end
end
