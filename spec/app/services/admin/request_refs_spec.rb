require "rails_helper"

# button_image_processing_request's default parent_request factory (prompt_message) creates its own
# unrelated command_prompt_to_image_request as a side effect, which would leak into this spec's
# assertions since Admin::RequestRefs is always global. Passing parent_request: explicitly avoids that.
describe Admin::RequestRefs do
  subject(:call) { described_class.call(filters:, sort:) }

  let(:sort) { Admin::SortParams::DEFAULT }

  let(:filters) { Admin::RequestsQuery::Filters.new(user_search:, date_from:, date_to:) }
  let(:user_search) { nil }
  let(:date_from) { nil }
  let(:date_to) { nil }

  let(:user) { create(:user, :with_balance) }
  let!(:command_request) { create(:command_prompt_to_image_request, user:, created_at: 2.days.ago) }
  let!(:button_request) do
    create(:button_image_processing_request, :completed, command_request:, parent_request: command_request,
                                                         created_at: 1.day.ago)
  end

  it "returns refs for both command and button requests, most recent first" do
    expect(call.map(&:id)).to eq([button_request.id, command_request.id])
    expect(call.map(&:klass)).to eq([ButtonImageProcessingRequest, CommandPromptToImageRequest])
  end

  context "when filtering by user search" do
    let(:user_search) { user.name }

    it "only returns refs belonging to matching users" do
      other_user = create(:user, :with_balance, name: "Someone Else")
      other_command = create(:command_prompt_to_image_request, user: other_user, created_at: 3.hours.ago)
      create(:button_image_processing_request, :completed, command_request: other_command,
                                                           parent_request: other_command, created_at: 2.hours.ago)

      expect(call.map(&:id)).to contain_exactly(button_request.id, command_request.id)
    end
  end

  context "when filtering by date range" do
    let(:date_from) { 1.day.ago.to_date.to_s }

    it "excludes refs outside the range" do
      expect(call.map(&:id)).to contain_exactly(button_request.id)
    end
  end

  context "when sorting by kind" do
    let(:sort) { Admin::Sort.new("kind", "asc") }

    it { expect(call.map(&:klass)).to eq([ButtonImageProcessingRequest, CommandPromptToImageRequest]) }
  end
end
