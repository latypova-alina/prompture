require "rails_helper"

describe Admin::FieldsHelper do
  subject { helper.admin_field_value(name, value) }

  let(:name) { "image_url" }

  context "when the value is a URL" do
    let(:value) { "https://media.example.com/a.png" }

    it { is_expected.to eq('<a target="_blank" rel="noopener" href="https://media.example.com/a.png">Open</a>') }
  end

  context "when the value is nil" do
    let(:value) { nil }

    it { is_expected.to eq('<span class="muted">—</span>') }
  end

  context "when the value is plain text" do
    let(:name) { "processor" }
    let(:value) { "flux_image" }

    it { is_expected.to eq("flux_image") }
  end

  context "when the value is a long Telegram picture id" do
    let(:name) { "picture_id" }
    let(:value) { "AgACAgIAAxkBAAIQumq6kUK7ZWmMJ84cH" }

    it { is_expected.to include('<span class="truncated-short">AgACAgIAAxkBA...</span>') }
    it { is_expected.to include("<summary>more</summary>") }
    it { is_expected.to include(%(<span class="truncated-full">#{value}</span>)) }
  end

  context "when the Telegram id is already short" do
    let(:name) { "file_id" }
    let(:value) { "AgACpic" }

    it { is_expected.to eq("AgACpic") }
  end

  context "when the field is a file size" do
    let(:name) { "size" }
    let(:value) { 372_761 }

    it { is_expected.to eq("364 KB (372,761 bytes)") }
  end

  context "when the field is a picture dimension" do
    let(:name) { "width" }
    let(:value) { 1280 }

    it { is_expected.to eq("1280 px") }
  end
end
