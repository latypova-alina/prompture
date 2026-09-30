require "rails_helper"

describe Admin::ButtonRequestsQuery do
  subject(:call) { described_class.call(user:, filters:, page:) }

  let(:filters) do
    Admin::ButtonRequestsQuery::Filters.new(type:, status:, processor:, command_type:, date_from:, date_to:)
  end

  let(:user) { create(:user, :with_balance) }
  let(:type) { nil }
  let(:status) { nil }
  let(:processor) { nil }
  let(:command_type) { nil }
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

  context "when filtering by status" do
    let(:status) { "COMPLETED" }

    it { expect(call.records).to contain_exactly(image_request) }

    context "given a different casing than what's stored" do
      let(:status) { "completed" }

      it "still matches, case-insensitively" do
        expect(call.records).to contain_exactly(image_request)
      end
    end
  end

  context "when filtering by processor" do
    let(:processor) { "flux_image" }

    it "only returns requests of types that have that processor" do
      expect(call.records).to contain_exactly(image_request)
    end

    it "does not error on types without a processor column" do
      expect { call }.not_to raise_error
    end
  end

  context "when filtering by command type" do
    let!(:audio_button_request) do
      create(:button_audio_processing_request, command_request: audio_command, created_at: 3.days.ago)
    end

    context "matching the command type" do
      let(:command_type) { "CommandPromptToAudioRequest" }

      it { expect(call.records).to contain_exactly(audio_button_request) }
    end

    context "matching a different command type" do
      let(:command_type) { "CommandPromptToImageRequest" }

      it { expect(call.records).to contain_exactly(image_request, extend_prompt_request) }
    end
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

  describe ".count" do
    subject(:count) { described_class.count(user:, filters:, page:) }

    it { is_expected.to eq(2) }

    context "when filtering by status" do
      let(:status) { "COMPLETED" }

      it { is_expected.to eq(1) }
    end
  end

  describe ".processor_options" do
    subject(:processor_options) { described_class.processor_options }

    it "includes processors from types that have them" do
      expect(processor_options).to include("flux_image", "elevenlabs_v3_audio", "local_ffmpeg_merge")
    end
  end
end
