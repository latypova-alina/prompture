require "rails_helper"

describe Admin::CommandRequestsQuery do
  subject(:call) { described_class.call(user:, type:, date_from:, date_to:, page:) }

  let(:user) { create(:user, :with_balance) }
  let(:type) { nil }
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
end
