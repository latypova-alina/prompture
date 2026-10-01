require "rails_helper"

describe Admin::RefSorter do
  subject { described_class.call(refs, sort: Admin::Sort.new("status", direction)).map(&:id) }

  let(:now) { Time.current }
  let(:refs) do
    [
      Admin::RequestRef.new(ButtonImageProcessingRequest, 1, now - 3.days, "PENDING"),
      Admin::RequestRef.new(ButtonImageProcessingRequest, 2, now - 2.days, nil),
      Admin::RequestRef.new(ButtonImageProcessingRequest, 3, now - 1.day, "COMPLETED"),
      Admin::RequestRef.new(ButtonImageProcessingRequest, 4, now, "PENDING"),
      Admin::RequestRef.new(ButtonImageProcessingRequest, 5, now - 4.days, nil)
    ]
  end

  context "when ascending" do
    let(:direction) { "asc" }

    it { is_expected.to eq([3, 4, 1, 2, 5]) }
  end

  context "when descending" do
    let(:direction) { "desc" }

    it { is_expected.to eq([4, 1, 3, 2, 5]) }
  end

  context "when created_at ties too" do
    let(:direction) { "asc" }
    let(:refs) do
      [
        Admin::RequestRef.new(ButtonImageProcessingRequest, 7, now, "PENDING"),
        Admin::RequestRef.new(ButtonImageProcessingRequest, 9, now, "PENDING")
      ]
    end

    it { is_expected.to eq([9, 7]) }
  end
end
