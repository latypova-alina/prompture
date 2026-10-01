require "rails_helper"

describe Admin::FieldsHelper do
  subject { helper.admin_field_value(value) }

  context "when the value is a URL" do
    let(:value) { "https://media.example.com/a.png" }

    it { is_expected.to eq('<a target="_blank" rel="noopener" href="https://media.example.com/a.png">Open</a>') }
  end

  context "when the value is nil" do
    let(:value) { nil }

    it { is_expected.to eq('<span class="muted">—</span>') }
  end

  context "when the value is plain text" do
    let(:value) { "flux_image" }

    it { is_expected.to eq("flux_image") }
  end
end
