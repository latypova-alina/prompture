require "rails_helper"

describe StoreImage::ButtonHandler::ParseButtonRequest do
  subject(:result) { described_class.call(button_request:) }

  let(:user) { create(:user) }
  let(:command_request) { create(:command_prompt_to_image_request, user:) }
  let(:record) { create(:user_image_url_message, command_request:, parent_request: command_request) }
  let(:button_request) { "accept_terms:#{record.class.name}:#{record.id}" }

  it "parses the record type and id from the compound button request" do
    expect(result.record_type).to eq(record.class.name)
    expect(result.record_id).to eq(record.id.to_s)
  end

  it "resolves the user through the record's command_request" do
    expect(result.user).to eq(user)
  end

  it "marks terms as accepted for downstream steps" do
    expect(result.terms_accepted).to eq(true)
  end
end
