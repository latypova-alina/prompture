require "rails_helper"

describe Admin::RefsFromRelations do
  subject { described_class.call(relations, sort: Admin::Sort.new(key, direction)) }

  let(:direction) { "asc" }
  let(:anna) { create(:user, :with_balance, name: "anna") }
  let(:boris) { create(:user, :with_balance, name: "Boris") }
  let(:anna_command) { create(:command_prompt_to_audio_request, user: anna, created_at: 3.days.ago) }
  let(:boris_command) do
    create(:command_prompt_to_image_request, user: boris, category: "cats", created_at: 2.days.ago)
  end

  let!(:audio_request) do
    create(:button_audio_processing_request, command_request: anna_command, parent_request: anna_command,
                                             status: "pending", created_at: 2.days.ago)
  end
  let!(:image_request) do
    create(:button_image_processing_request, :completed, command_request: boris_command,
                                                         parent_request: boris_command, created_at: 1.day.ago)
  end
  let!(:extend_request) do
    create(:button_extend_prompt_request, command_request: boris_command, parent_request: boris_command,
                                          created_at: 3.days.ago)
  end

  let(:relations) do
    Admin::ButtonRequestTypes::ALL.index_with { |klass| klass.where(id: [audio_request, image_request, extend_request]) }
  end

  def ids
    subject.map { |ref| [ref.klass, ref.id] }
  end

  context "when sorting by user name" do
    let(:key) { "user" }

    it "sorts case-insensitively through each button's command request" do
      expect(ids.first).to eq([ButtonAudioProcessingRequest, audio_request.id])
    end
  end

  context "when sorting by status" do
    let(:key) { "status" }

    it "compares case-insensitively" do
      expect(subject.map(&:sort_value)).to eq(%w[COMPLETED PENDING PENDING])
    end
  end

  context "when sorting by cost" do
    let(:key) { "cost" }

    it { expect(subject.map(&:sort_value)).to eq(subject.map(&:sort_value).sort) }
    it { expect(subject.map(&:sort_value)).to all(be_present) }
  end

  context "when sorting by processor" do
    let(:key) { "processor" }

    it { expect(subject.map(&:sort_value)).to eq(%w[elevenlabs_v3_audio extend_prompt flux_image]) }
  end

  context "when sorting by type" do
    let(:key) { "type" }

    it do
      expect(subject.map(&:klass)).to eq(
        [ButtonAudioProcessingRequest, ButtonExtendPromptRequest, ButtonImageProcessingRequest]
      )
    end
  end

  context "when sorting by command" do
    let(:key) { "command" }

    it do
      expect(subject.map(&:sort_value)).to all(match(/\ACommandPromptTo(Audio|Image)Request#\d{20}\z/))
    end
  end

  context "when sorting command requests by category" do
    let(:key) { "category" }
    let(:relations) do
      { CommandPromptToImageRequest => CommandPromptToImageRequest.where(id: boris_command),
        CommandPromptToAudioRequest => CommandPromptToAudioRequest.where(id: anna_command) }
    end

    context "when descending" do
      let(:direction) { "desc" }

      it "still puts nil categories last" do
        expect(ids).to eq([[CommandPromptToImageRequest, boris_command.id],
                           [CommandPromptToAudioRequest, anna_command.id]])
      end
    end
  end

  context "when sorting by created (default)" do
    let(:key) { "created" }
    let(:direction) { "desc" }

    it do
      expect(ids).to eq([[ButtonImageProcessingRequest, image_request.id],
                         [ButtonAudioProcessingRequest, audio_request.id],
                         [ButtonExtendPromptRequest, extend_request.id]])
    end
  end
end
