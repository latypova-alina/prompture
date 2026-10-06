require "rails_helper"

describe ChatEvents::RetentionJob do
  subject(:perform) { described_class.new.perform }

  let!(:old_event) { create(:chat_event, occurred_at: 91.days.ago) }
  let!(:recent_event) { create(:chat_event, occurred_at: 89.days.ago) }

  it { expect { perform }.to change(ChatEvent, :count).by(-1) }

  it "keeps events from the last 90 days" do
    perform

    expect(ChatEvent.all).to contain_exactly(recent_event)
  end
end
