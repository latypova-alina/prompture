require "rails_helper"

describe Admin::UserGenerationHistory do
  subject(:call) { described_class.call(user:) }

  let(:user) { create(:user, :with_balance) }

  context "when the user has no command requests" do
    it "returns an empty array" do
      expect(call).to eq([])
    end
  end

  context "when the user has command requests across different types" do
    let!(:image_command) { create(:command_prompt_to_image_request, user:) }
    let!(:audio_command) { create(:command_prompt_to_audio_request, user:) }

    it "returns one entry per command request" do
      expect(call.map(&:command_request)).to contain_exactly(image_command, audio_command)
    end

    it "orders entries by most recently created first" do
      image_command.update!(created_at: 2.days.ago)
      audio_command.update!(created_at: 1.day.ago)

      expect(call.map(&:command_request)).to eq([audio_command, image_command])
    end

    it "does not include command requests belonging to another user" do
      other_user = create(:user, :with_balance)
      create(:command_prompt_to_image_request, user: other_user)

      expect(call.map(&:command_request)).to contain_exactly(image_command, audio_command)
    end
  end

  context "when a command request has button requests linked via command_request" do
    let(:command) { create(:command_prompt_to_image_request, user:) }
    let!(:image_request) { create(:button_image_processing_request, :completed, command_request: command) }
    let!(:extend_prompt_request) { create(:button_extend_prompt_request, command_request: command) }

    it "nests all matching button requests under the command request" do
      entry = call.find { |e| e.command_request == command }

      expect(entry.button_requests).to contain_exactly(image_request, extend_prompt_request)
    end

    it "does not include button requests linked to a different command request" do
      other_command = create(:command_prompt_to_image_request, user:)
      create(:button_image_processing_request, :completed, command_request: other_command)

      entry = call.find { |e| e.command_request == command }

      expect(entry.button_requests).to contain_exactly(image_request, extend_prompt_request)
    end

    it "orders button requests by created_at ascending" do
      image_request.update!(created_at: 1.day.ago)
      extend_prompt_request.update!(created_at: Time.current)

      entry = call.find { |e| e.command_request == command }

      expect(entry.button_requests).to eq([image_request, extend_prompt_request])
    end
  end

  context "when a command request has no button requests" do
    let!(:command) { create(:command_prompt_to_audio_request, user:) }

    it "returns an empty button_requests array" do
      entry = call.find { |e| e.command_request == command }

      expect(entry.button_requests).to eq([])
    end
  end
end
