require "rails_helper"

describe Admin::CommandRequestsQuery do
  subject(:call) { described_class.call(user: query_user, filters:, page:) }

  let(:filters) do
    Admin::CommandRequestsQuery::Filters.new(type:, user_search:, has_button_requests:, date_from:, date_to:)
  end

  let(:user) { create(:user, :with_balance) }
  let(:query_user) { user }
  let(:type) { nil }
  let(:user_search) { nil }
  let(:has_button_requests) { nil }
  let(:date_from) { nil }
  let(:date_to) { nil }
  let(:page) { 1 }

  let!(:image_command) { create(:command_prompt_to_image_request, user:, created_at: 2.days.ago) }
  let!(:audio_command) { create(:command_prompt_to_audio_request, user:, created_at: 1.day.ago) }

  it "returns all of the user's command requests, most recent first" do
    expect(call.records).to eq([audio_command, image_command])
  end

  it "does not include another user's command requests" do
    other_user = create(:user, :with_balance)
    create(:command_prompt_to_image_request, user: other_user)

    expect(call.records).to contain_exactly(image_command, audio_command)
  end

  context "when filtering by type" do
    let(:type) { "CommandPromptToAudioRequest" }

    it { expect(call.records).to contain_exactly(audio_command) }
  end

  context "when filtering by an unknown type" do
    let(:type) { "NotARealType" }

    it "falls back to all types" do
      expect(call.records).to contain_exactly(image_command, audio_command)
    end
  end

  context "when filtering by date range" do
    let(:date_from) { 1.5.days.ago.to_date.to_s }

    it { expect(call.records).to contain_exactly(audio_command) }
  end

  context "when no user is given (global view)" do
    let(:query_user) { nil }

    it "returns command requests across all users" do
      other_user = create(:user, :with_balance)
      other_command = create(:command_prompt_to_image_request, user: other_user, created_at: 3.hours.ago)

      expect(call.records).to include(image_command, audio_command, other_command)
    end

    context "when filtering by user search" do
      let(:user_search) { user.name }

      it "scopes to command requests belonging to matching users" do
        other_user = create(:user, :with_balance, name: "Someone Else")
        create(:command_prompt_to_image_request, user: other_user, created_at: 3.hours.ago)

        expect(call.records).to contain_exactly(image_command, audio_command)
      end
    end
  end

  context "when filtering by has_button_requests" do
    let!(:with_button_command) { create(:command_prompt_to_image_request, user:, created_at: 3.hours.ago) }

    before { create(:button_image_processing_request, :completed, command_request: with_button_command) }

    context "with 'with'" do
      let(:has_button_requests) { "with" }

      it { expect(call.records).to contain_exactly(with_button_command) }
    end

    context "with 'without'" do
      let(:has_button_requests) { "without" }

      it { expect(call.records).to contain_exactly(image_command, audio_command) }
    end
  end

  context "when there are more than 20 matching command requests" do
    before { create_list(:command_prompt_to_image_request, 20, user:) }

    it "paginates to 20 records on the first page" do
      expect(call.records.size).to eq(20)
    end

    context "on the second page" do
      let(:page) { 2 }

      it { expect(call.records.size).to eq(2) }
    end
  end

  describe ".count" do
    subject(:count) { described_class.count(user: query_user, filters:) }

    it { is_expected.to eq(2) }

    context "when filtering by type" do
      let(:type) { "CommandPromptToAudioRequest" }

      it { is_expected.to eq(1) }
    end
  end
end
