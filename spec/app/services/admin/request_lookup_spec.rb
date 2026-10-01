require "rails_helper"

describe Admin::RequestLookup do
  subject(:call) { described_class.call(types: Admin::CommandRequestsQuery::TYPES, slug:, id:) }

  let(:command_request) { create(:command_edit_image_request) }
  let(:slug) { "edit_image" }
  let(:id) { command_request.id }

  it { is_expected.to eq(command_request) }

  context "when the type is unknown" do
    let(:slug) { "Kernel" }

    it { expect { call }.to raise_error(ActiveRecord::RecordNotFound) }
  end

  context "when the id does not exist" do
    let(:id) { 0 }

    it { expect { call }.to raise_error(ActiveRecord::RecordNotFound) }
  end
end
