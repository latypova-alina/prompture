require "rails_helper"

describe Admin::SortLinksHelper do
  subject { helper.sortable_header("Status", "status", sort) }

  let(:sort) { Admin::SortParams::DEFAULT }

  before do
    allow(helper).to receive(:request).and_return(
      instance_double(ActionDispatch::Request, path: "/button_requests",
                                               query_parameters: { "status" => "FAILED", "page" => "3" })
    )
  end

  it "keeps filters, drops page, and starts ascending" do
    is_expected.to eq(
      '<a class="sortable" href="/button_requests?direction=asc&amp;sort=status&amp;status=FAILED">Status</a>'
    )
  end

  context "when the column is active ascending" do
    let(:sort) { Admin::Sort.new("status", "asc") }

    it { is_expected.to include("direction=desc").and include("Status ▲").and include("sortable-active") }
  end

  context "when the column is active descending" do
    let(:sort) { Admin::Sort.new("status", "desc") }

    it { is_expected.to include("direction=asc").and include("Status ▼") }
  end
end
