require "rails_helper"

# button_image_processing_request's default parent_request factory (prompt_message) creates its own
# unrelated command_prompt_to_image_request as a side effect, which would leak into this spec's
# assertions since Admin::RequestsQuery is always global (unlike the per-user queries, there's no
# way to scope a test around it). Passing parent_request: explicitly avoids that side effect.
describe Admin::RequestsQuery do
  subject(:call) { described_class.call(filters:, page:) }

  let(:filters) { Admin::RequestsQuery::Filters.new(user_search:, date_from:, date_to:) }
  let(:user_search) { nil }
  let(:date_from) { nil }
  let(:date_to) { nil }
  let(:page) { 1 }

  let(:user) { create(:user, :with_balance) }
  let!(:command_request) { create(:command_prompt_to_image_request, user:, created_at: 2.days.ago) }
  let!(:button_request) do
    create(:button_image_processing_request, :completed, command_request:, parent_request: command_request,
                                                         created_at: 1.day.ago)
  end

  it "combines command and button requests, most recent first" do
    expect(call.records).to eq([button_request, command_request])
  end

  it "does not include another user's requests when filtering by user" do
    other_user = create(:user, :with_balance, name: "Someone Else")
    other_command = create(:command_prompt_to_image_request, user: other_user, created_at: 3.hours.ago)
    other_button = create(:button_image_processing_request, :completed, command_request: other_command,
                                                                        parent_request: other_command,
                                                                        created_at: 2.hours.ago)

    expect(call.records).to include(command_request, button_request, other_command, other_button)
  end

  context "when filtering by user search" do
    let(:user_search) { user.name }

    it "only returns requests belonging to matching users" do
      other_user = create(:user, :with_balance, name: "Someone Else")
      other_command = create(:command_prompt_to_image_request, user: other_user, created_at: 3.hours.ago)
      create(:button_image_processing_request, :completed, command_request: other_command,
                                                           parent_request: other_command, created_at: 2.hours.ago)

      expect(call.records).to contain_exactly(command_request, button_request)
    end
  end

  context "when filtering by date range" do
    let(:date_from) { 1.day.ago.to_date.to_s }

    it "excludes rows outside the range" do
      expect(call.records).to contain_exactly(button_request)
    end
  end

  context "when there are more than 20 matching requests combined" do
    before { create_list(:command_prompt_to_image_request, 25, user:) }

    it "paginates to 20 records on the first page" do
      expect(call.records.size).to eq(20)
    end

    context "on the second page" do
      let(:page) { 2 }

      it { expect(call.records.size).to eq(7) }
    end
  end
end
